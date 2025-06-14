output "service_url" {
  description = "URL pública do serviço ECS via Load Balancer"
  value       = module.ecs_base.alb_dns
}
