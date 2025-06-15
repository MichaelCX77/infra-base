provider "aws" {
  region = var.aws_region
}

module "ecs_app" {
  source             = "../modules/ecs_app"
  project_name       = var.project_name
  cpu                = var.cpu
  memory             = var.memory
  container_port     = var.container_port
  desired_count      = var.desired_count
  capacity_provider  = var.capacity_provider
  subnet_ids         = var.subnet_ids
  security_group_id  = var.security_group_id
  cluster_id         = var.cluster_id
  target_group_arn   = var.target_group_arn
}