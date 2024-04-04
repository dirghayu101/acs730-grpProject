terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami                    = "ami-051f8a213df8bc089"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-06c4b300c050d1f2c"]
  subnet_id              = "subnet-0511a56df620c7b88"

  tags = {
    Name = var.instance_name
  }
}
