provider "aws" {
  region = var.aws_region
}

module "storage" {
  source = "../../modules/storage"

  bucket_name  = "test-django-terraform-2026"
  environment  = "dev"
  project_name = "django-infrastructure"
}

module "network" {
  source = "../../modules/network"

  vpc_name     = "django-infrastructure-dev"
  environment  = "dev"
  project_name = "django-infrastructure"

  vpc_cidr          = "10.0.0.0/16"
  availability_zone = "ap-southeast-2a"
}

module "security" {
  source = "../../modules/security"

  vpc_id              = module.network.vpc_id
  security_group_name = "django-infrastructure-dev-ec2"
  environment         = "dev"
  project_name        = "django-infrastructure"
  ssh_cidrs = [
    "223.29.215.50/32",
  ]
}
