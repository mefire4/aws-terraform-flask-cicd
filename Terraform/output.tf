output "ecr_repository_url" {
  value = aws_ecr_repository.my_repo.repository_url
}

output "ec2_public_ip" {
  value = aws_instance.my_instance.public_ip
}