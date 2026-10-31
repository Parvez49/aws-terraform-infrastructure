provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "django-infrastructure-tfstate"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "django-infrastructure-terraform-state"
    Environment = "shared"
    Project     = "django-infrastructure"
    ManagedBy   = "Terraform"
    Purpose     = "Terraform Remote State"
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}
