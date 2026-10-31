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
