output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.api.function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.api.arn
}

output "lambda_function_url" {
  description = "URL of the Lambda function"
  value       = aws_lambda_function_url.api.function_url
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.api.repository_url
}

output "ecr_repository_name" {
  description = "Name of the ECR repository"
  value       = aws_ecr_repository.api.name
}

output "deployed_image_tag" {
  description = "The image tag currently deployed to Lambda"
  value       = var.image_tag
}

output "deployed_image_uri" {
  description = "The full image URI currently deployed to Lambda"
  value       = aws_lambda_function.api.image_uri
}
