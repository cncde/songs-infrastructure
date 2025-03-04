output "state_bucket_name" {
  description = "The name of the S3 bucket for OpenTofu state"
  value       = aws_s3_bucket.tf_state.bucket
}
