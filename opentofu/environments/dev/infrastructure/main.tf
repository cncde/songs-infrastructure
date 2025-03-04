terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.88.0"
    }
  }

  backend "s3" {
    bucket = "songs-opentofu-state-dev"
    key    = "dev-infrastructure.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "state" {
  source      = "../../../modules/state"
  environment = "dev"
}
