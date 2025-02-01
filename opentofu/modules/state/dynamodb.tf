resource "aws_dynamodb_table" "state_lock" {
  name         = "songs-state-lock-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled = true
    kms_key_arn = aws_kms_key.state_lock_key.arn
  }

  tags = {
    Service = "songs"
  }
}
