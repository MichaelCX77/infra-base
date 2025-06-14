provider "aws" {
  region = var.aws_region
}

module "ecs_infra" {
  source         = "../modules/ecs_infra"
  project_name    = var.project_name
  container_port  = var.container_port
  vpc_id          = var.vpc_id
  subnet_ids      = var.subnet_ids
}