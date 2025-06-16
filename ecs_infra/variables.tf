# Região e Identificação
variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados"
}

variable "project_name" {
  description = "Nome base do projeto"
}

# Configurações de Rede
variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de subnets públicas para Load Balancer e ECS"
  type        = list(string)
}

# Configurações do Container
variable "container_port" {
  description = "Porta exposta pelo container"
}

# Configurações de Health Check do Load Balancer
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

# Configurações de Autoscaling
variable "min_capacity" {
  description = "Quantidade mínima de tasks no ECS service"
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "Quantidade máxima de tasks no ECS service"
  type        = number
  default     = 4
}

variable "cpu_target_value" {
  description = "Percentual de CPU para acionar o autoscaling (ex: 50.0)"
  type        = number
  default     = 75.0
}

# Configurações de Schedule para Escalonamento (Down)
variable "schedule_down_cron" {
  description = "Cron expression para agendar a escala para baixo (desligar)"
  type        = string
  default     = "cron(0 18 * * ? *)"
}

variable "schedule_down_min_capacity" {
  description = "Min capacity para escala down"
  type        = number
  default     = 0
}

variable "schedule_down_max_capacity" {
  description = "Max capacity para escala down"
  type        = number
  default     = 0
}

# Configurações de Schedule para Escalonamento (Up)
variable "schedule_up_cron" {
  description = "Cron expression para agendar a escala para cima (ligar)"
  type        = string
  default     = "cron(0 12 * * ? *)" # Exemplo: todo dia às 12h UTC
}

variable "schedule_up_min_capacity" {
  description = "Min capacity para escala up"
  type        = number
  default     = 2
}

variable "schedule_up_max_capacity" {
  description = "Max capacity para escala up"
  type        = number
  default     = 4
}