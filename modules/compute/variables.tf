variable "key_name" {
  description = "Name of the AWS EC2 key pair"
  type        = string
}

variable "public_key_path" {
  description = "Path to the local SSH public key"
  type        = string
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where EC2 will be launched"
  type        = string
}

variable "security_group_id" {
  description = "ID of the EC2 security group"
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
