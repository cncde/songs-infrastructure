resource "aws_dynamodb_table" "songs" {
  name         = "${var.prefix}songs-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "index"

  attribute {
    name = "index"
    type = "N"
  }

  tags = {
    Environment = var.environment
    Project     = "Songs Infrastructure"
  }
}
