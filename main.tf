provider "aws" {
  region = var.aws_region
}

module "ecs_base" {
  source         = "./modules/ecs_service"

  project_name   = var.project_name
  image          = var.image
  cpu            = var.cpu
  memory         = var.memory
  desired_count  = var.desired_count
  container_port = var.container_port
}
