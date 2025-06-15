provider "aws" {
  region = var.aws_region
}

module "ecs_infra" {
  source         = "../modules/ecs_infra"
  aws_region      = var.aws_region
  project_name    = var.project_name
  container_port  = var.container_port
  vpc_id          = var.vpc_id
  subnet_ids      = var.subnet_ids

  # Repasse do health check
  health_check_path                   = var.health_check_path
  health_check_interval          = var.health_check_interval
  health_check_timeout           = var.health_check_timeout
  health_check_healthy_threshold = var.health_check_healthy_threshold
  unhealthy_threshold            = var.unhealthy_threshold
}