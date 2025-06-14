# ECS Base Infra

Infraestrutura reutilizável com Terraform para expor uma API rodando em ECS Fargate com baixo custo.

## Recursos

- VPC e Subnets públicas
- ECS Cluster (Fargate)
- Load Balancer com alvo no ECS
- Parametrização de CPU, memória e imagem

## Variáveis

- `project_name`: Nome do projeto
- `image`: Imagem Docker
- `cpu`: CPU da task (ex: 256)
- `memory`: Memória da task (ex: 512)
- `desired_count`: Número de instâncias
- `container_port`: Porta do container

## Exemplo de uso

Veja [examples/basic-api](examples/basic-api) para um exemplo funcional.
