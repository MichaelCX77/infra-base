variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados"
  default     = "sa-east-1"
}

variable "project_name" {
  description = "Nome base do projeto"
}

variable "cpu" {
  description = "Quantidade de CPU para a task"
}

variable "memory" {
  description = "Quantidade de memória para a task"
}

variable "desired_count" {
  description = "Número de instâncias da task"
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