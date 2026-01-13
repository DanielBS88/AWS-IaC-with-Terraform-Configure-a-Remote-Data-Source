variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
}

variable "project_id" {
  description = "Project identifier used for tagging resources"
  type        = string
}

variable "state_bucket" {
  description = "S3 bucket name where the remote Terraform state is stored"
  type        = string
}

variable "state_key" {
  description = "S3 key path to the remote Terraform state file"
  type        = string
}
