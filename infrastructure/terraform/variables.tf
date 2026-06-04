variable "aws_region" {
  description = "AWS region for the state bucket."
  type        = string
  default     = "us-west-2"
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform remote state."
  type        = string
}
