module "storage" {
  source = "../../modules/storage"

  bucket_name = "test-django-terraform-2026"
}

module "network" {
  source = "../../modules/network"

  vpc_name = "${var.project_name}-${var.environment}"

  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  availability_zone   = "ap-southeast-2a"
}

module "security" {
  source = "../../modules/security"

  vpc_id              = module.network.vpc_id
  security_group_name = "${var.project_name}-${var.environment}-ec2"

  # Real values live in terraform.tfvars, which is gitignored, so home IP
  # addresses stay out of the repository.
  ssh_cidrs = var.ssh_cidrs
}

module "iam" {
  source = "../../modules/iam"

  role_name          = "${var.project_name}-${var.environment}-ec2"
  storage_bucket_arn = module.storage.bucket_arn
}

module "compute" {
  source = "../../modules/compute"

  # SSH key pair
  key_name        = "${var.project_name}-${var.environment}"
  public_key_path = "${path.root}/aws-django-dev.pub"

  # EC2 configuration
  instance_name = "${var.project_name}-${var.environment}-ec2"
  instance_type = "t3.micro"

  # Network configuration
  subnet_id         = module.network.public_subnet_id
  security_group_id = module.security.security_group_id

  # Instance role, so the app reaches S3 without stored credentials
  iam_instance_profile_name = module.iam.instance_profile_name
}
