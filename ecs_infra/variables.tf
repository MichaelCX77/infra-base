variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados"
}

variable "project_name" {
  description = "Nome base do projeto"
}

variable "container_port" {
  description = "Porta exposta pelo container"
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de subnets públicas para Load Balancer e ECS"
  type        = list(string)
}

variable "health_check_path" {
  description = "Caminho HTTP para o health check"
  type        = string
}

variable "health_check_interval" {
  description = "Intervalo em segundos entre as verificações de health check"
  type        = number
}

variable "health_check_timeout" {
  description = "Timeout em segundos para o health check"
  type        = number
}

variable "health_check_healthy_threshold" {
  description = "Número de respostas sucessivas para considerar o target saudável"
  type        = number
}

variable "unhealthy_threshold" {
  description = "Número de respostas falhas para considerar o target não saudável"
  type        = number
}
