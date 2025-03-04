resource "aws_kms_key" "state_key" {
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

resource "aws_kms_alias" "state_key_alias" {
  name          = "alias/songs-opentofu-state-${var.environment}"
  target_key_id = aws_kms_key.state_key.key_id

}
