provider "aws" {
  region = var.aws_region
}

module "ecs_app" {
  source = "../modules/ecs_app"

  # --- Configuração geral ---
  aws_region   = var.aws_region
  project_name = var.project_name

  # --- Recursos de computação ---
  cpu            = var.cpu
  memory         = var.memory
  container_port = var.container_port
  desired_count  = var.desired_count
  capacity_provider = var.capacity_provider

  # --- Rede e segurança ---
  subnet_ids        = var.subnet_ids
  security_group_id = var.security_group_id

  # --- Recursos do ECS ---
  cluster_id       = var.cluster_id
  target_group_arn = var.target_group_arn

  # --- Imagem e permissões ---
  image              = var.image
  execution_role_arn = var.execution_role_arn
}
