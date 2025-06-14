output "ecr_repository_url" {
  value = aws_ecr_repository.repo.repository_url
}

output "cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "alb_target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}