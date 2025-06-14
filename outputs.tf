output "alb_dns_name" {
  value = module.ecs.alb_dns_name
}

output "ecr_repository_url" {
  value = module.ecs.ecr_repository_url
}