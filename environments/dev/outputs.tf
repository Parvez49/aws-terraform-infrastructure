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