terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.15.0"
    }
  }

  backend "s3" {
    bucket = "songs-opentofu-state-preview"
    key    = "preview-infrastructure.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

locals {
  environment = terraform.workspace == "default" ? "preview" : terraform.workspace
}

variable "image_tag" {
  description = "Container tag to deploy to the preview Lambda"
  type        = string
  default     = "latest"
}

module "database" {
  source      = "../../../modules/database"
  environment = local.environment
}

module "api" {
  source           = "../../../modules/api"
  environment      = local.environment
  songs_table_name = module.database.songs_table_name
  image_tag        = var.image_tag
}

module "frontend" {
  source      = "../../../modules/frontend"
  environment = local.environment
  prefix      = "${local.environment}-"
}

output "frontend_url" {
  description = "Frontend website URL"
  value       = "https://${module.frontend.frontend_bucket}.s3-website.eu-central-1.amazonaws.com"
}

output "backend_url" {
  description = "Preview backend Lambda URL"
  value       = module.api.lambda_function_url
}

output "songs_table_name" {
  description = "Preview songs table name"
  value       = module.database.songs_table_name
}

output "workspace_name" {
  description = "Terraform workspace used for this preview"
  value       = terraform.workspace
}
