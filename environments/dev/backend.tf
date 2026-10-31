terraform {
  backend "s3" {
    bucket       = "django-infrastructure-tfstate"
    key          = "dev/terraform.tfstate"
    region       = "ap-southeast-2"
    encrypt      = true
    use_lockfile = true
  }
}
