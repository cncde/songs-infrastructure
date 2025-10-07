variable "prefix" {
  default = ""
  type    = string
}

variable "environment" {
  description = "The environment for the deployment (e.g., dev, prod)"
  type        = string
}

variable "image_tag" {
  description = "The tag of the container image to deploy (e.g., latest, v1.0.0, sha-abc123)"
  type        = string
}

variable "songs_table_name" {
  description = "Name of the songs DynamoDB table"
  type        = string
}
