terraform {
  # 1.10.0 is the floor for the S3 backend's use_lockfile (see backend.tf).
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
