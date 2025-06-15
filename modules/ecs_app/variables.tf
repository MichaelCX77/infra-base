variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados"
  default     = "sa-east-1"
}

# Nome do projeto, usado para nomear recursos ECS, ALB, etc.
variable "project_name" {
  type = string
}

# CPU reservada para a task ECS (ex: "256", "512", "1024")
variable "cpu" {
  type = string
}

# Memória reservada para a task ECS (ex: "512", "1024", "2048")
variable "memory" {
  type = string
}

# Porta no container onde a aplicação está escutando
variable "container_port" {
  type = number
}

# Quantidade desejada de instâncias (tasks) do serviço ECS
variable "desired_count" {
  type = number
}

# Provedor de capacidade para o ECS (ex: "FARGATE", "FARGATE_SPOT")
variable "capacity_provider" {
  type = string
}

# Lista de IDs das subnets onde o serviço ECS será executado
variable "subnet_ids" {
  type = list(string)
}

# ID do grupo de segurança para o serviço ECS
variable "security_group_id" {
  type = string
  default = ""
}

# ID do cluster ECS onde o serviço será criado
variable "cluster_id" {
  type = string
  default = ""
}

# ARN do target group do Application Load Balancer para associar ao serviço ECS
variable "target_group_arn" {
  type = string
  default = ""
}

# URI da imagem docker que será usada na task ECS (sem tag, adicionamos ":latest" no main.tf)
variable "image" {
  type    = string
  default = ""
}