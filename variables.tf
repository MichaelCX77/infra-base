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

variable "vpc_name" {
  description = "Nome da VPC"
  type        = string
}

