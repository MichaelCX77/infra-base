variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados"
  type        = string
}

variable "project_name" {
  description = "Nome base do projeto"
  type        = string
}

variable "container_port" {
  description = "Porta exposta pelo container"
  type        = number
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

variable "min_capacity" {
  description = "Quantidade mínima de tasks no ECS service"
  type        = number
}

variable "max_capacity" {
  description = "Quantidade máxima de tasks no ECS service"
  type        = number
}

variable "cpu_target_value" {
  description = "Percentual de CPU para acionar o autoscaling (ex: 50.0)"
  type        = number
}

variable "schedule_down_cron" {
  description = "Cron expression para agendar a escala para baixo (desligar)"
  type        = string
}

variable "schedule_down_min_capacity" {
  description = "Min capacity para escala down"
  type        = number
}

variable "schedule_down_max_capacity" {
  description = "Max capacity para escala down"
  type        = number
}

variable "schedule_up_cron" {
  description = "Cron expression para agendar a escala para cima (ligar)"
  type        = string
}

variable "schedule_up_min_capacity" {
  description = "Min capacity para escala up"
  type        = number
}

variable "schedule_up_max_capacity" {
  description = "Max capacity para escala up"
  type        = number
}