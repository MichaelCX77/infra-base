provider "aws" {
  region = var.aws_region
}

module "ecs_service" {
  source         = "./modules/ecs_service"
  project_name   = var.project_name
  vpc_id         = var.vpc_id
  subnet_ids     = var.subnet_ids
  container_port = var.container_port
}

module "ecs_task" {
  source             = "./modules/ecs_task"
  project_name       = var.project_name
  cpu                = var.cpu
  memory             = var.memory
  container_port     = var.container_port
  desired_count      = var.desired_count
  capacity_provider  = var.capacity_provider
  subnet_ids         = var.subnet_ids
  security_group_id  = module.ecs_service.alb_security_group_id
  cluster_id         = module.ecs_service.cluster_id
  target_group_arn   = module.ecs_service.alb_target_group_arn
  lb_listener_depends_on = [module.ecs_service.alb_target_group_arn]
}
