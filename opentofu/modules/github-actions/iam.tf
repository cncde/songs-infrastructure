# Role assumed by the GitHub Actions runner to deploy infrastructure
resource "aws_iam_role" "infrastructure_opentofu" {
  name        = "GHA-songs-infrastructure-opentofu"
  description = "Role assumed by GitHub Actions to deploy the infrastructure"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${local.account_id}:oidc-provider/token.actions.githubusercontent.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.infrastructure_repo_name}:*"
          },
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

# state bucket
resource "aws_iam_policy" "infrastructure_state_bucket_name" {
  name        = "GHA-songs-infrastructure-opentofu-state-bucket"
  description = "Policy to allow GitHub Actions to manage the infrastructure state bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:GetBucketPolicy",
          "s3:GetBucketAcl",
          "s3:GetBucketCORS",
          "s3:GetBucketWebsite",
          "s3:GetBucketVersioning",
          "s3:GetAccelerateConfiguration",
          "s3:GetBucketRequestPayment",
          "s3:GetBucketLogging",
          "s3:GetLifecycleConfiguration",
          "s3:GetReplicationConfiguration",
          "s3:GetEncryptionConfiguration",
          "s3:GetBucketObjectLockConfiguration",
          "s3:GetBucketTagging"
        ],
        Resource = [
          "arn:aws:s3:::${var.state_bucket_name}"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
        ],
        Resource = [
          "arn:aws:s3:::${var.state_bucket_name}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:GetKeyPolicy",
          "kms:GetKeyRotationStatus",
          "kms:ListResourceTags",
          "kms:ListAliases"
        ],
        Resource = "*",
        # Condition = {
        #   StringLike = {
        #     "kms:RequestAlias" = "alias/${var.state_bucket_name}-*"
        #   }
        # }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "infrastructure_state_bucket_name_role_policy_attachment" {
  role       = aws_iam_role.infrastructure_opentofu.name
  policy_arn = aws_iam_policy.infrastructure_state_bucket_name.arn
}

# DynamoDB
resource "aws_iam_policy" "infrastructure_opentofu_dynamodb" {
  name        = "GHA-songs-infrastructure-opentofu-dynamodb"
  description = "Policy to allow GitHub Actions to manage DynamoDB tables"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:CreateTable",
          "dynamodb:DescribeTable",
          "dynamodb:UpdateTable",
          "dynamodb:DeleteTable",
          "dynamodb:ListTables",
          "dynamodb:TagResource",
          "dynamodb:UntagResource",
          "dynamodb:ListTagsOfResource",
          "dynamodb:DescribeContinuousBackups",
          "dynamodb:DescribeTimeToLive"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "infrastructure_opentofu_dynamodb_role_policy_attachment" {
  role       = aws_iam_role.infrastructure_opentofu.name
  policy_arn = aws_iam_policy.infrastructure_opentofu_dynamodb.arn
}

# Lambda and ECR for API
resource "aws_iam_policy" "infrastructure_opentofu_api" {
  name        = "GHA-songs-infrastructure-opentofu-api"
  description = "Policy to allow GitHub Actions to manage Lambda and ECR for API"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "lambda:CreateFunction",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration",
          "lambda:GetFunction",
          "lambda:GetFunctionConfiguration",
          "lambda:DeleteFunction",
          "lambda:ListFunctions",
          "lambda:TagResource",
          "lambda:UntagResource",
          "lambda:ListTags",
          "lambda:CreateFunctionUrlConfig",
          "lambda:UpdateFunctionUrlConfig",
          "lambda:GetFunctionUrlConfig",
          "lambda:DeleteFunctionUrlConfig"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ecr:CreateRepository",
          "ecr:DescribeRepositories",
          "ecr:DeleteRepository",
          "ecr:PutLifecyclePolicy",
          "ecr:GetLifecyclePolicy",
          "ecr:DeleteLifecyclePolicy",
          "ecr:PutImageScanningConfiguration",
          "ecr:GetImageScanningConfiguration",
          "ecr:TagResource",
          "ecr:UntagResource",
          "ecr:ListTagsForResource"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "iam:CreateRole",
          "iam:GetRole",
          "iam:DeleteRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:GetRolePolicy",
          "iam:ListRolePolicies",
          "iam:ListAttachedRolePolicies",
          "iam:CreatePolicy",
          "iam:GetPolicy",
          "iam:DeletePolicy",
          "iam:GetPolicyVersion",
          "iam:ListPolicyVersions",
          "iam:TagRole",
          "iam:UntagRole",
          "iam:TagPolicy",
          "iam:UntagPolicy",
          "iam:PassRole"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "infrastructure_opentofu_api_role_policy_attachment" {
  role       = aws_iam_role.infrastructure_opentofu.name
  policy_arn = aws_iam_policy.infrastructure_opentofu_api.arn
}
