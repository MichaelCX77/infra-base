# Gera sufixo aleatório para evitar conflito de nomes
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

# VPC existente pelo nome da tag
data "aws_vpcs" "myvpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_vpc" "myvpc" {
  id = data.aws_vpcs.myvpc.ids[0]
}

# Zonas de disponibilidade
data "aws_availability_zones" "available" {}

# Subnets públicas com tag "Public = true"
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.myvpc.id]
  }

  filter {
    name   = "tag:Public"
    values = ["true"]
  }
}

# Security group para o ALB
resource "aws_security_group" "alb_sg" {
  vpc_id = data.aws_vpc.myvpc.id

  ingress {
    from_port   = 80
    to_port     = 80
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

# Load Balancer com nome único
resource "aws_lb" "this" {
  name               = "${var.project_name}-${random_string.suffix.result}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.aws_subnets.public.ids

  lifecycle {
    create_before_destroy = true
  }
}

# Target group
resource "aws_lb_target_group" "this" {
  name        = "${var.project_name}-tg"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.myvpc.id
  target_type = "ip"

  lifecycle {
    create_before_destroy = true
  }
}

# Listener HTTP
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

# ECR repository protegido contra destruição
resource "aws_ecr_repository" "repo" {
  name = var.project_name

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [image_tag_mutability, encryption_configuration]
  }
}

# ECS cluster
resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-cluster"

  lifecycle {
    prevent_destroy = true
  }
}

# ECS Task Definition
resource "aws_ecs_task_definition" "this" {
  family                   = "${var.project_name}-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  network_mode             = "awsvpc"

  container_definitions = jsonencode([{
    name  = var.project_name
    image = var.image
    portMappings = [{
      containerPort = var.container_port
      protocol      = "tcp"
    }]
  }])
}

# ECS Service
resource "aws_ecs_service" "this" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_count

  network_configuration {
    subnets         = data.aws_subnets.public.ids
    security_groups = [aws_security_group.alb_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = var.project_name
    container_port   = var.container_port
  }

  depends_on = [aws_lb_listener.http]
}
