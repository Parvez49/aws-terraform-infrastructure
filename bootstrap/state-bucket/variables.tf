variable "aws_region" {
  description = "AWS region hosting the Terraform state bucket"
  type        = string
  default     = "ap-southeast-2"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "aws_region must be a valid AWS region name, e.g. ap-southeast-2."
  }
}

variable "state_bucket_name" {
  description = "Globally unique name of the Terraform state bucket"
  type        = string
  default     = "django-infrastructure-tfstate"
}

variable "state_version_retention_days" {
  description = "Days to retain noncurrent Terraform state versions"
  type        = number
  default     = 90

  validation {
    condition     = var.state_version_retention_days >= 30
    error_message = "Keep at least 30 days of state history so a bad apply stays recoverable."
  }
}
