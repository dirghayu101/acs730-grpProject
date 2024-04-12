terraform {
  backend "s3" {
    bucket = "acs-final-grp-17"
    key    = "staging/balance-and-scale/terraform.tfstate"
    region = "us-east-1"
  }
}