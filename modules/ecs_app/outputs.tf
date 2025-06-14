output "ecs_service_name" {
  value = aws_ecs_service.this.name
}

output "ecs_task_family" {
  value = aws_ecs_task_definition.this.family
}