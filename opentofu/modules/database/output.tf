output "songs_table_name" {
  description = "Name of the songs DynamoDB table"
  value       = aws_dynamodb_table.songs.name
}

output "songs_table_arn" {
  description = "ARN of the songs DynamoDB table"
  value       = aws_dynamodb_table.songs.arn
}

output "comments_table_name" {
  description = "Name of the comments DynamoDB table"
  value       = aws_dynamodb_table.comments.name
}

output "comments_table_arn" {
  description = "ARN of the comments DynamoDB table"
  value       = aws_dynamodb_table.comments.arn
}
