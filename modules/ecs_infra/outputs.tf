output "cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "security_group_id" {
  value = aws_security_group.alb_sg.id
}