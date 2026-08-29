resource "aws_dynamodb_table" "my_dynamo" {
  name         = "items-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "item_id"

  attribute {
    name = "item_id"
    type = "S"
  }
}