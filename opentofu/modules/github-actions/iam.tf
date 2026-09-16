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

# state bucket and S3 infrastructure
resource "aws_iam_policy" "infrastructure_state_bucket_name" {
  name        = "GHA-songs-infrastructure-opentofu-state-s3"
  description = "Policy to allow GitHub Actions to manage the infrastructure state bucket and S3 resources"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:ListBucket",
          "s3:GetBucketPolicy",
          "s3:PutBucketPolicy",
          "s3:DeleteBucketPolicy",
          "s3:GetBucketAcl",
          "s3:PutBucketAcl",
          "s3:GetBucketCORS",
          "s3:PutBucketCORS",
          "s3:GetBucketWebsite",
          "s3:PutBucketWebsite",
          "s3:DeleteBucketWebsite",
          "s3:GetBucketVersioning",
          "s3:PutBucketVersioning",
          "s3:GetAccelerateConfiguration",
          "s3:GetBucketRequestPayment",
          "s3:GetBucketLogging",
          "s3:PutBucketLogging",
          "s3:GetLifecycleConfiguration",
          "s3:PutLifecycleConfiguration",
          "s3:GetReplicationConfiguration",
          "s3:GetEncryptionConfiguration",
          "s3:PutEncryptionConfiguration",
          "s3:GetBucketObjectLockConfiguration",
          "s3:GetBucketTagging",
          "s3:PutBucketTagging",
          "s3:GetBucketPublicAccessBlock",
          "s3:PutBucketPublicAccessBlock",
        ],
        Resource = [
          "arn:aws:s3:::${var.state_bucket_name}",
          "arn:aws:s3:::*lieder.neokatechumenalerweg.de"
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
          "arn:aws:s3:::${var.state_bucket_name}/*",
          "arn:aws:s3:::*lieder.neokatechumenalerweg.de/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "kms:CreateKey",
          "kms:CreateAlias",
          "kms:DeleteAlias",
          "kms:PutKeyPolicy",
          "kms:EnableKeyRotation",
          "kms:DisableKey",
          "kms:ScheduleKeyDeletion",
          "kms:TagResource",
          "kms:UntagResource",
        ],
        Resource = "arn:aws:kms:*:${local.account_id}:key/*",
        Condition = {
          StringLike = {
            "kms:RequestAlias" = "alias/songs-*"
          }
        }
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
        ],
        Resource = "arn:aws:kms:*:${local.account_id}:key/*",
        Condition = {
          StringEquals = {
            "aws:ResourceTag/Service" = "songs"
          }
        }
      },
      {
        Effect = "Allow",
        Action = [
          "kms:ListAliases",
        ],
        Resource = "*"
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
          "dynamodb:TagResource",
          "dynamodb:UntagResource",
          "dynamodb:ListTagsOfResource",
          "dynamodb:DescribeContinuousBackups",
          "dynamodb:DescribeTimeToLive",
        ],
        Resource = "arn:aws:dynamodb:*:${local.account_id}:table/songs-*"
      },
      {
        Effect = "Allow",
        Action = [
          "dynamodb:ListTables",
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
          "lambda:TagResource",
          "lambda:UntagResource",
          "lambda:ListTags",
          "lambda:ListVersionsByFunction",
          "lambda:PublishVersion",
          "lambda:AddPermission",
          "lambda:RemovePermission",
          "lambda:GetPolicy",
          "lambda:CreateFunctionUrlConfig",
          "lambda:UpdateFunctionUrlConfig",
          "lambda:GetFunctionUrlConfig",
          "lambda:DeleteFunctionUrlConfig",
        ],
        Resource = "arn:aws:lambda:*:${local.account_id}:function:songs-*"
      },
      {
        Effect = "Allow",
        Action = [
          "lambda:ListFunctions",
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
          "ecr:ListTagsForResource",
          "ecr:SetRepositoryPolicy",
          "ecr:GetRepositoryPolicy",
          "ecr:DeleteRepositoryPolicy",
        ],
        Resource = "arn:aws:ecr:*:${local.account_id}:repository/songs-*"
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
          "iam:TagRole",
          "iam:UntagRole",
        ],
        Resource = "arn:aws:iam::${local.account_id}:role/songs-*"
      },
      {
        Effect = "Allow",
        Action = [
          "iam:CreatePolicy",
          "iam:GetPolicy",
          "iam:DeletePolicy",
          "iam:GetPolicyVersion",
          "iam:ListPolicyVersions",
          "iam:CreatePolicyVersion",
          "iam:DeletePolicyVersion",
          "iam:TagPolicy",
          "iam:UntagPolicy",
        ],
        Resource = "arn:aws:iam::${local.account_id}:policy/songs-*"
      },
      {
        Effect = "Allow",
        Action = [
          "iam:PassRole",
        ],
        Resource = "arn:aws:iam::${local.account_id}:role/songs-*",
        Condition = {
          StringEquals = {
            "iam:PassedToService" = "lambda.amazonaws.com"
          }
        }
      },
      {
        Effect = "Allow",
        Action = [
          "iam:GetPolicyVersion",
        ],
        Resource = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "infrastructure_opentofu_api_role_policy_attachment" {
  role       = aws_iam_role.infrastructure_opentofu.name
  policy_arn = aws_iam_policy.infrastructure_opentofu_api.arn
}
