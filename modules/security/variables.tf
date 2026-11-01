variable "vpc_id" {
  description = "ID of the VPC where the security group will be created"
  type        = string
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "ssh_cidrs" {
  description = "List of public IP CIDRs allowed to access EC2 through SSH"
  type        = list(string)
  default     = []
}
