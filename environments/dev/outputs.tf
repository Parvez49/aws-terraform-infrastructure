output "s3_bucket_name" {
  description = "Name of the Django storage bucket"
  value       = aws_s3_bucket.django_storage.bucket
}

output "s3_bucket_arn" {
  description = "ARN of the Django storage bucket"
  value       = aws_s3_bucket.django_storage.arn
}

output "s3_bucket_region" {
  description = "Region of the Django storage bucket"
  value       = var.aws_region
}