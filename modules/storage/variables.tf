variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Environment where the bucket is deployed"
  type        = string
}

variable "project_name" {
  description = "Name of the project using this bucket"
  type        = string
}