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

  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  availability_zone   = "ap-southeast-2a"
}

module "security" {
  source = "../../modules/security"

  vpc_id              = module.network.vpc_id
  security_group_name = "django-infrastructure-dev-ec2"
  environment         = "dev"
  project_name        = "django-infrastructure"
  ssh_cidrs = [
    "223.29.215.50/32",
    "223.29.215.61/32",
    "223.29.215.58/32",
    "223.29.215.54/32",
    "223.29.215.48/32",
    "223.29.215.0/24",
  ]
}

module "compute" {
  source = "../../modules/compute"

  # SSH key pair
  key_name        = "django-infrastructure-dev"
  public_key_path = "${path.root}/aws-django-dev.pub"

  # EC2 configuration
  instance_name = "django-infrastructure-dev-ec2"
  instance_type = "t3.micro"

  # Network configuration
  subnet_id         = module.network.public_subnet_id
  security_group_id = module.security.security_group_id

  # Environment
  environment  = "dev"
  project_name = "django-infrastructure"
}
