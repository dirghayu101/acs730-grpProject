variable "env" {
  type        = string
  description = "Environment Variable."
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

# Auto Scalling Group Variables
variable "min_instance_map" {
  type        = map(string)
  description = "Mapping of min number of instances to the env variable value."
  default = {
    "dev"     = 2
    "staging" = 3
    "prod"    = 3
  }
}

# Based on requirement this is environment independent.
variable "max_instance_size" {
  type        = number
  description = "Maximum number of instances for the ASG in any environment."
  default     = 4
}

variable "desired_instant_capacity" {
  type        = number
  description = "Desired capacity of instances."
  default     = 2
}

variable "asg_cpu_target" {
  type        = number
  description = "CPU utilisation arget value in the scaling policy for ASG."
  default     = 50
}
