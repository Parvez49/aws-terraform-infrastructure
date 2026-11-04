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

  validation {
    condition     = can(regex("^[a-z0-9]+[0-9][a-z]*\\.[a-z0-9]+$", var.instance_type))
    error_message = "instance_type must look like an EC2 instance type, e.g. t3.micro."
  }
}

variable "subnet_id" {
  description = "ID of the subnet where EC2 will be launched"
  type        = string
}

variable "security_group_id" {
  description = "ID of the EC2 security group"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "Name of the IAM instance profile to attach. Null attaches none."
  type        = string
  default     = null
}

variable "root_volume_size" {
  description = "Size of the root EBS volume in GiB"
  type        = number
  default     = 8

  validation {
    condition     = var.root_volume_size >= 8
    error_message = "root_volume_size must be at least 8 GiB for the Ubuntu AMI."
  }
}
