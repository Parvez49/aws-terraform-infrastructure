provider "aws" {
  region = var.aws_region
}

module "storage" {
  source = "../../modules/storage"

  bucket_name  = "test-django-terraform-2026"
  environment  = "dev"
  project_name = "django-infrastructure"
}
