variable "project_name" {
  description = "Nome do projeto / serviço"
  type        = string
}

variable "cpu" {
  description = "CPU units para a task ECS"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memória (MB) para a task ECS"
  type        = number
  default     = 512
}

variable "container_port" {
  description = "Porta exposta no container"
  type        = number
  default     = 8080
}

variable "desired_count" {
  description = "Número de instâncias desejadas do serviço ECS"
  type        = number
  default     = 1
}

variable "image" {
  description = "URI da imagem Docker com tag para ECS"
  type        = string
  default = ""
}
