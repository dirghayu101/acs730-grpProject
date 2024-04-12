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

variable "ami_id" {
  type        = string
  description = "Amazon ec2 ami ID."
  default     = "ami-051f8a213df8bc089"
}

variable "instance_type_map" {
  type        = map(string)
  description = "Mapping of environment and their instant type"
  default = {
    "dev"     = "t3.micro",
    "staging" = "t3.small"
    "prod"    = "t3.medium"
  }
}

variable "key_name" {
  type        = string
  description = "Key name value for SSH access."
  default     = "vockey"
}