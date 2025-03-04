#!/bin/bash

if [ -z "$1" ]; then
  echo "No environment provided. Please specify one of the following: dev, test, prod."
  exit 1
fi

ENVIRONMENT="$1"
shift

if [[ "$ENVIRONMENT" != "dev" && "$ENVIRONMENT" != "test" && "$ENVIRONMENT" != "prod" ]]; then
  echo "Invalid environment: $ENVIRONMENT. Please specify one of the following: dev, test, prod."
  exit 1
fi

PREFIX="echo "
if [ -z "$1" ]; then
  echo "No action parameter provided. Running in safe mode. Use --force to actually import the resources."
fi

if [ "$1" == "--force" ]; then
  PREFIX=""
fi

STATE_KEY=$(aws kms list-aliases --query "Aliases[?AliasName=='alias/songs-opentofu-state-${ENVIRONMENT}'].TargetKeyId" --output text)


if [ -z "${STATE_KEY}" ] || [[ "${STATE_KEY}" =~ \  ]]; then
  echo "Error: STATE_KEY is empty or contains spaces"
  exit 1
fi

# KMS
$PREFIX tofu import module.state.aws_kms_key.state_key "$STATE_KEY"
$PREFIX tofu import module.state.aws_kms_alias.state_key_alias "alias/songs-opentofu-state-${ENVIRONMENT}"
# S3
$PREFIX tofu import module.state.aws_s3_bucket.state_bucket "songs-opentofu-state-${ENVIRONMENT}"
$PREFIX tofu import module.state.aws_s3_bucket_public_access_block.state_bucket "songs-opentofu-state-${ENVIRONMENT}"
$PREFIX tofu import module.state.aws_s3_bucket_versioning.state_bucket "songs-opentofu-state-${ENVIRONMENT}"
$PREFIX tofu import module.state.aws_s3_bucket_server_side_encryption_configuration.state_bucket_encryption "songs-opentofu-state-${ENVIRONMENT}"
$PREFIX tofu import module.state.aws_s3_bucket_policy.state_bucket_policy "songs-opentofu-state-${ENVIRONMENT}"
