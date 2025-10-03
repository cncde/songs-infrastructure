variable "prefix" {
  default = ""
  type    = string
}

variable "environment" {
  description = "The environment for the deployment (e.g., dev, prod)"
  type        = string
}
