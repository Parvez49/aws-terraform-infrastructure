output "s3_bucket_name" {
  description = "Name of the Django storage bucket"
  value       = module.storage.bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the Django storage bucket"
  value       = module.storage.bucket_arn
}

output "s3_bucket_region" {
  description = "AWS region where the bucket is deployed"
  value       = var.aws_region
}

output "vpc_id" {
  description = "ID of the Dev VPC"
  value       = module.network.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the Dev VPC"
  value       = module.network.vpc_cidr
}

output "public_subnet_id" {
  description = "ID of the Dev public subnet"
  value       = module.network.public_subnet_id
}

output "public_subnet_cidr" {
  description = "CIDR block of the Dev public subnet"
  value       = module.network.public_subnet_cidr
}

output "private_subnet_id" {
  description = "ID of the Dev private subnet"
  value       = module.network.private_subnet_id
}

output "private_subnet_cidr" {
  description = "CIDR block of the Dev private subnet"
  value       = module.network.private_subnet_cidr
}

output "ec2_instance_id" {
  description = "ID of the Dev EC2 instance"
  value       = module.compute.instance_id
}

output "ec2_public_ip" {
  description = "Public IP of the Dev EC2 instance"
  value       = module.compute.instance_public_ip
}

output "ec2_private_ip" {
  description = "Private IP of the Dev EC2 instance"
  value       = module.compute.instance_private_ip
}

output "ec2_public_dns" {
  description = "Public DNS of the Dev EC2 instance"
  value       = module.compute.instance_public_dns
}

output "security_group_id" {
  description = "ID of the Dev EC2 security group"
  value       = module.security.security_group_id
}

output "ec2_iam_role_name" {
  description = "Name of the IAM role attached to the Dev EC2 instance"
  value       = module.iam.role_name
}

output "ec2_instance_profile_name" {
  description = "Name of the instance profile attached to the Dev EC2 instance"
  value       = module.iam.instance_profile_name
}
