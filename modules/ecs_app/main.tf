locals {
  # Extrai o nome da role de execução a partir do ARN
  execution_role_name = replace(var.execution_role_arn, "arn:aws:iam::[0-9]+:role/", "")
}

# Grupo de logs CloudWatch para armazenar logs do ECS, com retenção de 7 dias
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = 7
}

# Definição da Task ECS usando Fargate
resource "aws_ecs_task_definition" "this" {
  family                   = "${var.project_name}-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  network_mode             = "awsvpc"
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([{
    name  = var.project_name
    image = var.image

    portMappings = [{
      containerPort = var.container_port
      protocol      = "tcp"
    }]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/${var.project_name}"
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = var.project_name
      }
    }
  }])
}

# Serviço ECS que gerencia a execução das tasks
resource "aws_ecs_service" "this" {
  name            = "${var.project_name}-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count

  # Estratégia de provedores de capacidade (FARGATE, FARGATE_SPOT, etc)
  capacity_provider_strategy {
    capacity_provider = var.capacity_provider
    weight            = 1
  }

  # Configuração de rede da task
  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [var.security_group_id]
    assign_public_ip = true
  }

  # Load Balancer - integração com target group
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.project_name
    container_port   = var.container_port
  }
}
