terraform {
  backend "s3" {
    bucket = "acs-final-grp-17"
    key    = "prod/computing_setup/terraform.tfstate"
    region = "us-east-1"
  }
}