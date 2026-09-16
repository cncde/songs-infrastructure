resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "${var.prefix}lieder.neokatechumenalerweg.de"

  # Add tags
  tags = {
    Environment = var.environment
    Project     = "Songs Infrastructure"
  }
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
