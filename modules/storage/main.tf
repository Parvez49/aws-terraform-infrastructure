resource "aws_s3_bucket" "django_storage" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_public_access_block" "django_storage" {
  bucket = aws_s3_bucket.django_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "django_storage" {
  bucket = aws_s3_bucket.django_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "django_storage" {
  bucket = aws_s3_bucket.django_storage.id

  versioning_configuration {
    status = "Enabled"
  }
}