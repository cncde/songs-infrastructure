variable "infrastructure_repo_name" {
  description = "The name of the repository that contains the infrastructure code"
  type        = string
  default     = "cncde/songs-infrastructure"
}

variable "state_bucket_name" {
  description = "The name of the S3 bucket to store the state file"
  type        = string
}

variable "kms_deletion_window_in_days" {
  description = "The number of days after which the key is deleted after being scheduled for deletion"
  type        = number
  default     = 30

}