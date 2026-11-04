variable "role_name" {
  description = "Name of the IAM role and instance profile for EC2"
  type        = string
}

variable "storage_bucket_arn" {
  description = "ARN of the S3 bucket the instance is allowed to read and write"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:s3:::", var.storage_bucket_arn))
    error_message = "storage_bucket_arn must be an S3 bucket ARN, e.g. arn:aws:s3:::my-bucket."
  }
}

variable "enable_ssm_access" {
  description = "Attach AmazonSSMManagedInstanceCore so the instance is reachable via SSM Session Manager"
  type        = bool
  default     = false
}
