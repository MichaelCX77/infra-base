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
