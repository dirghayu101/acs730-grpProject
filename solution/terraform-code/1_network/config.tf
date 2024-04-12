terraform {
  backend "s3" {
    bucket = "acs-grp-17"
    key    = "prod/network/terraform.tfstate"
    region = "us-east-1"
  }
}
