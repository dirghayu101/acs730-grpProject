# AWS provider inclusion.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Local Block declaration for tag generation. To tag env value.
locals {
  default_tags = {
    "Owner" = "Group-17"
    "env"   = var.env
  }
}

#! Network Resource Declaration Starts Here.

# 1. VPC Declaration.
resource "aws_vpc" "main" {
  cidr_block = lookup(var.vpc_cidr_map, var.env)
  tags = merge(
    local.default_tags,
    {
      Name = format("%s-%s-vpc", var.env, var.grp)
    }
  )
}

# 2. Internet Gateway.
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    local.default_tags,
    {
      Name = format("%s-igw", var.env)
    }
  )
}

# 3. Public Subnet Creation.
resource "aws_subnet" "public_subnets" {
  count             = length(lookup(var.public_subnet_cidrs_map, var.env))
  vpc_id            = aws_vpc.main.id
  cidr_block        = lookup(var.public_subnet_cidrs_map, var.env)[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = merge(
    local.default_tags,
  { Name = "${var.env}-public-subnet-${count.index + 1}" })
}

# 4. Route Table creation for public subnets.
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  route {
    cidr_block = aws_vpc.main.cidr_block
    gateway_id = "local"
  }

  tags = merge(
    local.default_tags,
  { Name = "${var.env}-public-rtb" })
}

# 5. Route Table association creation for private subnets.
resource "aws_route_table_association" "public_association" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rtb.id
}

# 6. Private Subnet Creation.
resource "aws_subnet" "private_subnets" {
  count             = length(lookup(var.private_subnet_cidrs_map, var.env))
  vpc_id            = aws_vpc.main.id
  cidr_block        = lookup(var.private_subnet_cidrs_map, var.env)[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = merge(
    local.default_tags,
  { Name = "${var.env}-private-subnet-${count.index + 1}" })
}

# 7. NAT gateway creation for the private subnet.

# 7.1 Elastic IP creation for the NAT gateway.
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = merge(
    local.default_tags,
    { Name = "${var.env}-nat-eip" }
  )
}

# 7.2 NAT gateway creation.
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id
  tags = merge(
    local.default_tags,
    { Name = "${var.env}-nat-gw" }
  )
}

# 8. Route table creation for private subnets.
resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  route {
    cidr_block = aws_vpc.main.cidr_block
    gateway_id = "local"
  }
  tags = merge(
    local.default_tags,
  { Name = "${var.env}-private-rtb" })
}

# 9. Route table association creation for private subnets.
resource "aws_route_table_association" "private_association" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rtb.id
}