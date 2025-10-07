output "songs_table_name" {
  description = "Name of the songs DynamoDB table"
  value       = aws_dynamodb_table.songs.name
}

output "songs_table_arn" {
  description = "ARN of the songs DynamoDB table"
  value       = aws_dynamodb_table.songs.arn
}
