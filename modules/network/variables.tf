variable "vpc_name" {
  description = "Name of the VPC"
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

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet. Must fall inside vpc_cidr."
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet. Must fall inside vpc_cidr."
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone for the network resources"
  type        = string
}
