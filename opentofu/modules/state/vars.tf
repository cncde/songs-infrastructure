variable "environment" {
  description = "The environment to deploy the infrastructure to"
  type        = string
  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "The environment name must be either dev, test, or prod"
  }
}

variable "kms_deletion_window_in_days" {
  description = "The number of days after which the key is deleted after being scheduled for deletion"
  type        = number
  default     = 30
}

variable "prefix" {
  description = "The prefix to use for all resources, e.g. for different dev stacks"
  type        = string
  default     = ""
}