terraform {
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-east-1"
}

module "ecs_infra" {
  source       = "../../ecs_infra"

  # Configurações gerais e rede
  aws_region     = "us-east-1"
  project_name   = "my-ecs-project"
  container_port = 8080
  vpc_id         = "vpc-0a1b2c3d4e5f6g7h"
  subnet_ids     = ["subnet-0123456789abcdef0", "subnet-0fedcba9876543210"]

  # Configurações do health check do ALB / Target Group
  health_check_path               = "/health"
  health_check_interval           = 30
  health_check_timeout            = 5
  health_check_healthy_threshold  = 3
  unhealthy_threshold             = 2

  # Configurações de autoscaling
  min_capacity     = 2
  max_capacity     = 6
  cpu_target_value = 70.0

  # Agendamento para redução da escala (scale down)
  schedule_down_cron          = "cron(0 20 * * ? *)"  # todo dia às 20h UTC
  schedule_down_min_capacity  = 1
  schedule_down_max_capacity  = 2

  # Agendamento para aumento da escala (scale up)
  schedule_up_cron            = "cron(0 8 * * ? *)"   # todo dia às 8h UTC
  schedule_up_min_capacity    = 3
  schedule_up_max_capacity    = 5
}
