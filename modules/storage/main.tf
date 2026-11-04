# Environment / Project / ManagedBy come from the provider's default_tags in
# the environment root, so resources here only set Name.

resource "aws_s3_bucket" "django_storage" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
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

# Versioning keeps every overwrite forever unless something expires the old
# versions, so storage cost grows without bound. This caps that.
resource "aws_s3_bucket_lifecycle_configuration" "django_storage" {
  bucket = aws_s3_bucket.django_storage.id

  depends_on = [aws_s3_bucket_versioning.django_storage]

  rule {
    id     = "expire-noncurrent-versions"
    status = "Enabled"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
    }
  }

  rule {
    id     = "abort-incomplete-multipart-uploads"
    status = "Enabled"

    filter {}

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}
