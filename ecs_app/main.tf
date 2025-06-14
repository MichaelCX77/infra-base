provider "aws" {
  region = var.aws_region
}

module "ecs_app" {
  source             = "../modules/ecs_app"
  project_name       = var.project_name
  cpu                = var.cpu
  memory             = var.memory
  vpc_id             = var.vpc_id
  container_port     = var.container_port
  desired_count      = var.desired_count
  capacity_provider  = var.capacity_provider
  subnet_ids         = var.subnet_ids
  security_group_id  = module.ecs_infra.alb_security_group_id
  cluster_id         = module.ecs_infra.cluster_id
  target_group_arn   = module.ecs_infra.alb_target_group_arn
  lb_listener_depends_on = [module.ecs_infra.alb_target_group_arn]
}
