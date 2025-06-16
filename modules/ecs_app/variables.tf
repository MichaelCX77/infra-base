# Configurações gerais da AWS e do projeto
variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados"
  type        = string
}

variable "project_name" {
  description = "Nome do projeto, usado para nomear recursos ECS, ALB, etc."
  type        = string
}

# Configurações de recursos ECS (CPU, memória, contagem, capacidade)
variable "cpu" {
  description = "CPU reservada para a task ECS (ex: '256', '512', '1024')"
  type        = string
}

variable "memory" {
  description = "Memória reservada para a task ECS (ex: '512', '1024', '2048')"
  type        = string
}

variable "container_port" {
  description = "Porta no container onde a aplicação está escutando"
  type        = number
}

variable "desired_count" {
  description = "Quantidade desejada de instâncias (tasks) do serviço ECS"
  type        = number
}

variable "capacity_provider" {
  description = "Provedor de capacidade para o ECS (ex: 'FARGATE', 'FARGATE_SPOT')"
  type        = string
}

# Configurações de rede e segurança
variable "subnet_ids" {
  description = "Lista de IDs das subnets onde o serviço ECS será executado"
  type        = list(string)
}

variable "security_group_id" {
  description = "ID do grupo de segurança para o serviço ECS"
  type        = string
}

variable "cluster_id" {
  description = "ID do cluster ECS onde o serviço será criado"
  type        = string
}

variable "target_group_arn" {
  description = "ARN do target group do Application Load Balancer para associar ao serviço ECS"
  type        = string
}

# Imagem Docker e permissões
variable "image" {
  description = "URI da imagem docker que será usada na task ECS (sem tag, adicionamos ':latest' no main.tf)"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN da role de execução para a task ECS"
  type        = string
}
