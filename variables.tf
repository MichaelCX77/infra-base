variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados"
  default     = "sa-east-1"
}

variable "project_name" {
  description = "Nome base do projeto"
}

variable "cpu" {
  description = "Quantidade de CPU para a task"
  default     = "256"
}

variable "memory" {
  description = "Quantidade de memória para a task"
  default     = "512"
}

variable "desired_count" {
  description = "Número de instâncias da task"
  default     = 1
}

variable "container_port" {
  description = "Porta exposta pelo container"
  default     = 80
}

variable "image" {
  description = "Imagem Docker completa com tag (ex: 123456789012.dkr.ecr.sa-east-1.amazonaws.com/projeto:tag)"
  type        = string
  default     = ""
}
