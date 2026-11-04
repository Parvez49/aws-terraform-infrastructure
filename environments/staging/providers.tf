provider "aws" {
  region = var.aws_region

  # Applied to every taggable resource in this root, including resources inside
  # modules. Modules therefore only set their own Name tag.
  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    }
  }
}
