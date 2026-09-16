variable "prefix" {
  default = ""
  type    = string

  validation {
    condition     = var.prefix == "" || can(regex("^[a-z0-9][a-z0-9-]*-$", var.prefix))
    error_message = "The prefix must be empty or a DNS-compatible lowercase label ending with a hyphen."
  }
}

variable "environment" {
  description = "The environment for the deployment (e.g., dev, prod)"
  type        = string
}