provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "django_storage" {
  bucket = "test-django-terraform-2026"

  tags = {
    Name        = "django-storage"
    Environment = "dev"
    ManagedBy   = "Terraform"
    Project     = "django-infrastructure"
  }
}

# Block public access to the bucket.
resource "aws_s3_bucket_public_access_block" "django_storage" {
  bucket = aws_s3_bucket.django_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable server-side encryption.
resource "aws_s3_bucket_server_side_encryption_configuration" "django_storage" {
  bucket = aws_s3_bucket.django_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable versioning to help recover previous object versions.
resource "aws_s3_bucket_versioning" "django_storage" {
  bucket = aws_s3_bucket.django_storage.id

  versioning_configuration {
    status = "Enabled"
  }
}