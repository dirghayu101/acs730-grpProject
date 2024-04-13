# AWS provider declaration.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS Provider Configuration.
provider "aws" {
  region = "us-east-1"
}

# Data Block: Reference to the tfstate file of the network module.
data "terraform_remote_state" "network_module" {
  backend = "s3"
  config = {
    bucket = "acs-final-grp-17"
    key    = "${var.env}/network/terraform.tfstate"
    region = "us-east-1"
  }
}

# Local Block declaration for tag generation and variables retrieved from tfstate file of the networking module. 
locals {
  default_tags = {
    "Owner" = "Group-17"
    "env"   = var.env
  }
  vpc_id             = data.terraform_remote_state.network_module.outputs.vpc_id
  public_subnet_ids  = data.terraform_remote_state.network_module.outputs.public_subnet_ids
  private_subnet_ids = data.terraform_remote_state.network_module.outputs.private_subnet_ids
  ami_id             = var.ami_id
}

# Computing Resource Declaration Starts Here
# 1. Bastion Security Group Setup.
resource "aws_security_group" "bastion_sg" {
  name        = "allow_ssh"
  description = "Allows SSH connection."
  vpc_id      = local.vpc_id

  ingress {
    description      = "SSH from my IP."
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # -1 Denotes all protocol.
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge(
    local.default_tags,
    {
      Name = format("%s-%s-bastion-sg", var.env, var.grp)
    }
  )
}

# 2. Bastion Host Decalaration.
# Quick Note: In AWS they don't have a separate Bastion Host Service, instead Bastion is just an ec2 instance in a public subnet with SSH port open and a public IP address.
resource "aws_instance" "bastion_host" {
  ami                         = local.ami_id
  instance_type               = "t3.micro" # Bastion host is just going to be used for SSH
  key_name                    = var.key_name
  subnet_id                   = local.public_subnet_ids[0]
  security_groups             = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  tags = merge(
    local.default_tags,
    {
      Name = format("%s-%s-bastion-ec2", var.env, var.grp)
    }
  )
}

# 3. Web Server Security Group Setup. This will also be the SG of Load Balancer.
resource "aws_security_group" "web_server_sg" {
  name        = "allow_ssh_http"
  description = "Allows SSH and HTTP connection."
  vpc_id      = local.vpc_id

  ingress {
    description      = "SSH from all IPs."
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP from all IPs."
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # -1 Denotes all protocol.
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge(
    local.default_tags,
    {
      Name = format("%s-%s-webserver-sg", var.env, var.grp)
    }
  )
}

# 4. Web server instance setup. ASG template and initial web server setup will take place in this.
resource "aws_instance" "default_instance" {
  ami                         = local.ami_id
  instance_type               = lookup(var.instance_type_map, var.env)
  key_name                    = var.key_name
  subnet_id                   = local.private_subnet_ids[1]
  security_groups             = [aws_security_group.web_server_sg.id]
  associate_public_ip_address = false
  user_data = file("${path.module}/webserver-installation-script.sh")
  tags = merge(local.default_tags,
    {
      "Name" = format("%s-%s-default-ws", var.env, var.grp)
    }
  )
}
