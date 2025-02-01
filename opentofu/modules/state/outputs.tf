output "state_bucket_name" {
  description = "The name of the S3 bucket for OpenTofu state"
  value       = aws_s3_bucket.state_bucket.bucket
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table for state locking"
  value       = aws_dynamodb_table.state_lock.name
}
