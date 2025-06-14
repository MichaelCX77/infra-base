provider "aws" {
  region = var.aws_region
}

module "ecs_base" {
  source         = "./modules/ecs_service"

  project_name   = var.project_name
  cpu            = var.cpu
  memory         = var.memory
  desired_count  = var.desired_count
  container_port = var.container_port
  image          = "${module.ecs_base.ecr_repository_url}:latest"
  vpc_name       = var.vpc_name
}
