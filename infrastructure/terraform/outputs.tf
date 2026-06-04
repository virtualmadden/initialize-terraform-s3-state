output "state_bucket" {
  description = "S3 bucket name for Terraform remote state."
  value       = aws_s3_bucket.terraform_state.id
}

output "aws_region" {
  description = "Region where the state bucket was created."
  value       = var.aws_region
}
