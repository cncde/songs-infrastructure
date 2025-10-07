resource "aws_lambda_function" "api" {
  function_name = "${var.prefix}songs-api-${var.environment}"
  role          = aws_iam_role.lambda_execution.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.api.repository_url}:${var.image_tag}"
  timeout       = 30
  memory_size   = 512

  environment {
    variables = {
      SONGS_TABLE_NAME = var.songs_table_name
      ENVIRONMENT      = var.environment
    }
  }

  tags = {
    Environment = var.environment
    Project     = "Songs Infrastructure"
  }
}

resource "aws_lambda_function_url" "api" {
  function_name      = aws_lambda_function.api.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = false
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["*"]
    max_age           = 86400
  }
}
