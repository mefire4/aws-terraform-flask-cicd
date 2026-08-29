data "aws_ami" "ubuntu" {
  most_recent = "true"
   filter {
    name = "name"
    values = [ "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" ]
  }

   filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonic
}
 

resource "aws_instance" "my_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.my_profile.name

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io awscli
    systemctl start docker
    systemctl enable docker

    aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.my_repo.repository_url}
    docker pull ${aws_ecr_repository.my_repo.repository_url}:latest
    docker run -d -p 5000:5000 ${aws_ecr_repository.my_repo.repository_url}:latest
  EOF

  tags = {
    Name = "flask-app-instance"
  }
}