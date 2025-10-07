terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.15.0"
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

module "database" {
  source      = "../../../modules/database"
  environment = "dev"
}

module "api" {
  source           = "../../../modules/api"
  environment      = "dev"
  songs_table_name = module.database.songs_table_name
  image_tag        = "latest"
}