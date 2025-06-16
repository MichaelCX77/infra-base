# Random suffixes used to create unique resource names and avoid collisions
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "random_id" "tg_suffix" {
  byte_length = 4
}

# Data sources to get info about VPC and availability zones
data "aws_vpc" "myvpc" {
  id = var.vpc_id
}

data "aws_availability_zones" "available" {}

# Security Group for the Application Load Balancer (ALB)
resource "aws_security_group" "alb_sg" {
  vpc_id = data.aws_vpc.myvpc.id

  # Allow inbound HTTP traffic from anywhere on port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound traffic on container port from within the security group itself (self)
  ingress {
    from_port = var.container_port
    to_port   = var.container_port
    protocol  = "tcp"
    self      = true
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Application Load Balancer resource
resource "aws_lb" "this" {
  name               = "${var.project_name}-${random_string.suffix.result}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.subnet_ids

  lifecycle {
    create_before_destroy = true
  }
}

# Target Group for the ALB, routing to ECS tasks by IP
resource "aws_lb_target_group" "this" {
  name        = "${var.project_name}-tg-${random_id.tg_suffix.hex}"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.myvpc.id
  target_type = "ip"

  health_check {
    enabled             = true
    path                = var.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ALB Listener to forward HTTP traffic on port 80 to the target group
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

# ECR repository for Docker images
resource "aws_ecr_repository" "repo" {
  name = var.project_name

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [image_tag_mutability, encryption_configuration]
  }
}

# ECS Cluster to run the services
resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-cluster"

  lifecycle {
    prevent_destroy = true
  }
}

# Auto Scaling target for ECS service DesiredCount
resource "aws_appautoscaling_target" "ecs" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${aws_ecs_cluster.this.name}/${var.project_name}-service"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Auto Scaling policy based on ECS service CPU utilization
resource "aws_appautoscaling_policy" "cpu_policy" {
  name               = "${var.project_name}-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = var.cpu_target_value
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

# Scheduled auto scaling action to scale down at night
resource "aws_appautoscaling_scheduled_action" "scale_down_night" {
  name               = "${var.project_name}-scale-down"
  service_namespace  = aws_appautoscaling_target.ecs.service_namespace
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  schedule           = var.schedule_down_cron

  scalable_target_action {
    min_capacity = var.schedule_down_min_capacity
    max_capacity = var.schedule_down_max_capacity
  }
}

# Scheduled auto scaling action to scale up in the morning
resource "aws_appautoscaling_scheduled_action" "scale_up_morning" {
  name               = "${var.project_name}-scale-up"
  service_namespace  = aws_appautoscaling_target.ecs.service_namespace
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  schedule           = var.schedule_up_cron

  scalable_target_action {
    min_capacity = var.schedule_up_min_capacity
    max_capacity = var.schedule_up_max_capacity
  }
}
