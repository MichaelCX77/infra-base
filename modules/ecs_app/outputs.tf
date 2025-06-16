# Outputs relacionados ao serviço ECS
output "ecs_service_name" {
  value = aws_ecs_service.this.name
}

# Outputs relacionados à definição da task ECS
output "ecs_task_family" {
  value = aws_ecs_task_definition.this.family
}
