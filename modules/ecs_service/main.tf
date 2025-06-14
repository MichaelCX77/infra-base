resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "random_id" "tg_suffix" {
  byte_length = 4
}

data "aws_vpc" "myvpc" {
  id = var.vpc_id
}

data "aws_availability_zones" "available" {}

resource "aws_security_group" "alb_sg" {
  vpc_id = data.aws_vpc.myvpc.id

  ingress {
    from_port   = 80
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

resource "aws_lb_target_group" "this" {
  name        = "${var.project_name}-tg-${random_id.tg_suffix.hex}"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.myvpc.id
  target_type = "ip"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_ecr_repository" "repo" {
  name = var.project_name

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [image_tag_mutability, encryption_configuration]
  }
}

resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-cluster"

  lifecycle {
    prevent_destroy = true
  }
}
