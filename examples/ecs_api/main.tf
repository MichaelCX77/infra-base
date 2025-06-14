module "ecs_service" {
  source       = "../../modules/ecs_service"
  project_name = "meu-projeto-filho"
  cpu          = 256
  memory       = 512
  container_port = 8080
  desired_count = 2
}