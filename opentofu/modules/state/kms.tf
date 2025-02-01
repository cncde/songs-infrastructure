resource "aws_kms_key" "state_bucket_key" {
  description             = "KMS key to encrypt the state S3 bucket"  
  enable_key_rotation     = true
  is_enabled              = true
  deletion_window_in_days = var.kms_deletion_window_in_days

  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Service = "songs"
  }
}

resource "aws_kms_alias" "state_bucket_key_alias" {
  name          = "alias/songs-opentofu-state-${var.environment}"
  target_key_id = aws_kms_key.state_bucket_key.key_id
  
}

resource "aws_kms_key" "state_lock_key" {
  description = "KMS key to encrypt the state DynamoDB table"
  enable_key_rotation = true
  is_enabled = true
  deletion_window_in_days = var.kms_deletion_window_in_days

  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Service = "songs"
  }
}

resource "aws_kms_alias" "state_lock_key_alias" {
  name          = "alias/songs-state-lock-${var.environment}"
  target_key_id = aws_kms_key.state_lock_key.key_id
}
