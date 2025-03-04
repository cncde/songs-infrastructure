terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.88.0"
    }
  }

  backend "s3" {
    bucket = "songs-opentofu-state-dev"
    key    = "dev-github-actions.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "github-actions" {
  source            = "../../../modules/github-actions"
  state_bucket_name = "songs-opentofu-state-dev"
}