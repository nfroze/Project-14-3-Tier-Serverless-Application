resource "aws_dynamodb_table" "products" {
  name           = "serverless-products-${var.environment}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "serverless-products-${var.environment}"
    Environment = var.environment
    Project     = "3-tier-serverless"
  }
}