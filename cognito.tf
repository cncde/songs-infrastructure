resource "aws_cognito_user_group" "read_only_group" {
  user_pool_id = aws_cognito_user_pool.user_pool.id
  name         = "read-only"
  description  = "Read-only access group"
}

resource "aws_cognito_user_group" "admin_group" {
  user_pool_id = aws_cognito_user_pool.user_pool.id
  name         = "admin"
  description  = "Admin access group"
}
