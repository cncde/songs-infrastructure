resource "aws_dynamodb_table" "songs" {
  name         = "${var.prefix}songs-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Environment = var.environment
    Project     = "Songs Infrastructure"
  }
}

resource "aws_dynamodb_table" "comments" {
  name         = "${var.prefix}comments-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "song_id"
  range_key    = "id"

  attribute {
    name = "song_id"
    type = "S"
  }

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Environment = var.environment
    Project     = "Songs Infrastructure"
  }
}
