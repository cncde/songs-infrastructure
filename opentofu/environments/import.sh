#!/bin/bash

set -euo pipefail

if ! command -v aws &> /dev/null; then
  echo "AWS CLI is not installed. Please install it before running this script."
  exit 1
fi

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

if [ "$1" == "--apply" ]; then
  PREFIX=""
fi

STATE_KEY=$(aws kms list-aliases --query "Aliases[?AliasName=='alias/songs-tf-state-${ENVIRONMENT}'].TargetKeyId" --output text)


if [ -z "${STATE_KEY}" ] || [[ "${STATE_KEY}" =~ \  ]]; then
  echo "Error: STATE_KEY is empty or contains spaces"
  exit 1
fi

# KMS
$PREFIX tofu import module.state.aws_kms_key.tf_state "$STATE_KEY"
$PREFIX tofu import module.state.aws_kms_alias.tf_state_alias "alias/songs-tf-state-${ENVIRONMENT}"
# S3
$PREFIX tofu import module.state.aws_s3_bucket.tf_state "songs-tf-state-${ENVIRONMENT}"
$PREFIX tofu import module.state.aws_s3_bucket_public_access_block.tf_state "songs-tf-state-${ENVIRONMENT}"
$PREFIX tofu import module.state.aws_s3_bucket_versioning.tf_state "songs-tf-state-${ENVIRONMENT}"
$PREFIX tofu import module.state.aws_s3_bucket_server_side_encryption_configuration.tf_state "songs-tf-state-${ENVIRONMENT}"
$PREFIX tofu import module.state.aws_s3_bucket_policy.tf_state "songs-tf-state-${ENVIRONMENT}"
