terraform {
  backend "s3" {
    bucket = "acs-final-grp-17"
    key    = "dev/network/terraform.tfstate"
    region = "us-east-1"
  }
}