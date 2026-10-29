provider "aws" {
  region = var.aws_region
}

module "storage" {
  source = "../../modules/storage"

  bucket_name  = "django-infrastructure-staging-2026"
  environment  = "staging"
  project_name = "django-infrastructure"
}
