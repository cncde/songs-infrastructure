provider "aws" {
  region = var.region
}

resource "aws_cognito_user_pool" "user_pool" {
  name = var.cognito_user_pool_name

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  mfa_configuration = "ON"

  software_token_mfa_configuration {
    enabled = true
  }

}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name         = var.cognito_user_pool_client_name
  user_pool_id = aws_cognito_user_pool.user_pool.id

  explicit_auth_flows = [
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
}

resource "aws_cognito_user_pool_domain" "user_pool_domain" {
  domain      = var.cognito_user_pool_domain_name
  user_pool_id = aws_cognito_user_pool.user_pool.id
}
