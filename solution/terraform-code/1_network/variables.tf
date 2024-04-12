variable "env" {
  type        = string
  description = "Deployment Environment"
  default     = "dev"
}

variable "grp" {
  type        = string
  description = "Our group name."
  default     = "grp17"
}

variable "vpc_cidr_map" {
  type        = map(string)
  description = "Mapping of environment to VPC CIDR block"
  default = {
    "dev"     = "10.100.0.0/16",
    "staging" = "10.200.0.0/16",
    "prod"    = "10.250.0.0/16"
  }
}

variable "public_subnet_cidrs_map" {
  type        = map(list(string))
  description = "Mapping of environment to Public Subnet CIDR block"
  default = {
    "dev"     = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24"],
    "staging" = ["10.200.1.0/24", "10.200.2.0/24", "10.200.3.0/24"],
    "prod"    = ["10.250.1.0/24", "10.250.2.0/24", "10.250.3.0/24"]
  }
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones of our topology."
  default     = ["us-east-1b", "us-east-1c", "us-east-1d"]
}

variable "private_subnet_cidrs_map" {
  type        = map(list(string))
  description = "Mapping of environment to Private Subnet CIDR block"
  default = {
    "dev"     = ["10.100.4.0/24", "10.100.5.0/24", "10.100.6.0/24"],
    "staging" = ["10.200.4.0/24", "10.200.5.0/24", "10.200.6.0/24"],
    "prod"    = ["10.250.4.0/24", "10.250.5.0/24", "10.250.6.0/24"]
  }
}
