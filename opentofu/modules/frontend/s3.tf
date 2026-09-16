#trivy:ignore:AVD-AWS-0132 Static website assets are public and rebuilt from source, so a customer-managed KMS key adds cost without protecting confidential data.
#trivy:ignore:AVD-AWS-0090 Preview website assets are disposable build output; source control and CI rebuilds are the recovery path.
resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "${var.prefix}lieder.neokatechumenalerweg.de"

  tags = {
    Environment = var.environment
    Project     = "Songs Infrastructure"
  }
}

#trivy:ignore:AVD-AWS-0087 Public bucket policy is required for S3 website hosting.
#trivy:ignore:AVD-AWS-0093 Public access is required for S3 website hosting.
resource "aws_s3_bucket_public_access_block" "frontend_bucket" {
  bucket = aws_s3_bucket.frontend_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "frontend_bucket_website" {
  bucket = aws_s3_bucket.frontend_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
