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

# Data Block Declaration.
data "terraform_remote_state" "network_module" {
  backend = "s3"
  config = {
    bucket = "acs-final-grp-17"
    key    = "${var.env}/network/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "computing_module" {
  backend = "s3"
  config = {
    bucket = "acs-final-grp-17"
    key    = "${var.env}/computing_setup/terraform.tfstate"
    region = "us-east-1"
  }
}

# Local Block Declaration.
locals {
  default_tags = {
    "Owner" = "Group-17"
    "env"   = var.env
  }
  vpc_id               = data.terraform_remote_state.network_module.outputs.vpc_id
  public_subnet_ids    = data.terraform_remote_state.network_module.outputs.public_subnet_ids
  private_subnet_ids   = data.terraform_remote_state.network_module.outputs.private_subnet_ids
  default_webserver_id = data.terraform_remote_state.computing_module.outputs.default_webserver_id
  webserver_sg_id      = data.terraform_remote_state.computing_module.outputs.webserver_sg_id
}

# ! Balancing and Scaling Resource Declaration Starts Here.
# 1. Capturing AMI image of the default webserver.
resource "aws_ami_from_instance" "default_server_image" {
  name               = "default_server_image"
  source_instance_id = local.default_webserver_id
  tags = merge(
    local.default_tags,
    {
      Name = format("%s-%s-server-ami", var.env, var.grp)
    }
  )
}


# 2. Load Balancer's target group.
resource "aws_lb_target_group" "load_balancer_target" {
  name     = "asg-instances-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  tags = merge(
    local.default_tags,
    {
      Name = format("%s-%s-lb-target", var.env, var.grp)
    }
  )
}


# 3. Load Balancer Declaration.
resource "aws_lb" "load_balancer" {
  name               = "acs-final-lb"
  load_balancer_type = "application"
  security_groups    = [local.webserver_sg_id]
  subnets            = [for id in local.public_subnet_ids : id]
  internal           = false
  tags = merge(
    local.default_tags,
    {
      Name = format("%s-%s-load-balancer", var.env, var.grp)
    }
  )
}

# 4. Load Balancer Listener Declaration.
resource "aws_lb_listener" "load_balancer_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.load_balancer_target.arn
  }
  port     = "80"
  protocol = "HTTP"
  tags     = local.default_tags
}

# 5. Launch template creation.
resource "aws_launch_template" "asg_launch_template" {
  name                   = "asg-launch-template"
  image_id               = aws_ami_from_instance.default_server_image.id
  instance_type          = lookup(var.instance_type_map, var.env)
  key_name               = var.key_name
  vpc_security_group_ids = [local.webserver_sg_id]
  tags = merge(
    local.default_tags,
    {
      Name = format("%s-%s-launch-temp", var.env, var.grp)
    }
  )
}

# 6. ASG Creation.
resource "aws_autoscaling_group" "asg" {
  name     = "webserver-asg"
  min_size = lookup(var.min_instance_map, var.env)
  max_size = var.max_instance_size
  launch_template {
    id      = aws_launch_template.asg_launch_template.id
    version = "$Latest"
  }
  vpc_zone_identifier       = [for id in local.private_subnet_ids : id]
  health_check_grace_period = 300
}

# 7. ASG attachement to the load balancer.
resource "aws_autoscaling_attachment" "lb_attachement" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  lb_target_group_arn    = aws_lb_target_group.load_balancer_target.arn
}

# 8. ASG scaling policy definition.
resource "aws_autoscaling_policy" "policy_attachement" {
  name                   = "asg-scaling-policy"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.asg_cpu_target
  }
}

# 9. ASG Tag for the created instances.
resource "aws_autoscaling_group_tag" "asg_tag" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  tag {
    key                 = "Name"
    value               = format("%s-%s-asg-instant", var.env, var.grp)
    propagate_at_launch = true
  }
}
