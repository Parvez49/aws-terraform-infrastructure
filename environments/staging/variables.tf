variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "ap-southeast-2"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "aws_region must be a valid AWS region name, e.g. ap-southeast-2."
  }
}

variable "environment" {
  description = "Environment name, used in resource names and default tags"
  type        = string
  default     = "staging"

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "environment must be one of dev, staging or production."
  }
}

variable "project_name" {
  description = "Project name, used in resource names and default tags"
  type        = string
  default     = "django-infrastructure"
}
