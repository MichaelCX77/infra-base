provider "aws" {
  region = var.aws_region
}

module "ecs_infra" {
  source       = "../modules/ecs_infra"

  # Configurações gerais e rede
  aws_region     = var.aws_region
  project_name   = var.project_name
  container_port = var.container_port
  vpc_id         = var.vpc_id
  subnet_ids     = var.subnet_ids

  # Configurações do health check do ALB / Target Group
  health_check_path               = var.health_check_path
  health_check_interval           = var.health_check_interval
  health_check_timeout            = var.health_check_timeout
  health_check_healthy_threshold  = var.health_check_healthy_threshold
  unhealthy_threshold             = var.unhealthy_threshold

  # Configurações de autoscaling
  min_capacity     = var.min_capacity
  max_capacity     = var.max_capacity
  cpu_target_value = var.cpu_target_value

  # Agendamento para redução da escala (scale down)
  schedule_down_cron          = var.schedule_down_cron
  schedule_down_min_capacity  = var.schedule_down_min_capacity
  schedule_down_max_capacity  = var.schedule_down_max_capacity

  # Agendamento para aumento da escala (scale up)
  schedule_up_cron            = var.schedule_up_cron
  schedule_up_min_capacity    = var.schedule_up_min_capacity
  schedule_up_max_capacity    = var.schedule_up_max_capacity
}
