terraform {
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-east-1"
}

module "ecs_app" {
  source = "../../ecs_app"

  # --- Configuração geral ---
  aws_region   = "us-east-1"
  project_name = "my-ecs-project"

  # --- Recursos de computação ---
  cpu            = "512"
  memory         = "1024"
  container_port = 8080
  desired_count  = 3
  capacity_provider = "FARGATE"

  # --- Rede e segurança ---
  subnet_ids        = ["subnet-0123456789abcdef0", "subnet-0fedcba9876543210"]
  security_group_id = "sg-0a1b2c3d4e5f6g7h"

  # --- Recursos do ECS ---
  cluster_id       = "arn:aws:ecs:us-east-1:123456789012:cluster/my-cluster"
  target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/my-target-group/abcdef1234567890"

  # --- Imagem e permissões ---
  image              = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-app-image"
  execution_role_arn = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"
}
