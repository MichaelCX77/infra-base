variable "project_name" {
  description = "Nome do projeto / serviço"
  type        = string
}

variable "cpu" {
  description = "CPU units para a task ECS"
  type        = number
}

variable "memory" {
  description = "Memória (MB) para a task ECS"
  type        = number
}

variable "container_port" {
  description = "Porta exposta no container"
  type        = number
}

variable "desired_count" {
  description = "Número de instâncias desejadas do serviço ECS"
  type        = number
}

variable "image" {
  description = "URI da imagem Docker com tag para ECS"
  type        = string
  default = ""
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de subnets públicas para Load Balancer e ECS"
  type        = list(string)
}