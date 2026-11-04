variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block, e.g. 10.0.0.0/16."
  }
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet. Must fall inside vpc_cidr."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.public_subnet_cidr))
    error_message = "public_subnet_cidr must be a valid IPv4 CIDR block, e.g. 10.0.1.0/24."
  }
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet. Must fall inside vpc_cidr."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.private_subnet_cidr))
    error_message = "private_subnet_cidr must be a valid IPv4 CIDR block, e.g. 10.0.2.0/24."
  }
}

variable "availability_zone" {
  description = "Availability Zone for the network resources"
  type        = string
}
