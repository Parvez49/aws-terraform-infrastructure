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
  default     = "dev"

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

# Deliberately has no default. An empty default would silently strip every SSH
# rule from the security group on the next apply; a missing value fails loudly
# instead. Set it in terraform.tfvars locally, and via TF_VAR_ssh_cidrs in CI.
variable "ssh_cidrs" {
  description = "Public IP CIDRs allowed to reach the EC2 instance over SSH"
  type        = list(string)

  validation {
    condition     = length(var.ssh_cidrs) > 0
    error_message = "ssh_cidrs must list at least one CIDR, otherwise SSH is unreachable."
  }
}
