# ECS Base Infra

Infraestrutura reutilizável em Terraform para deployment de APIs no AWS ECS Fargate, com foco em baixo custo, escalabilidade e facilidade de uso.

---

## Índice

1. [Introdução](#introdução)
2. [Estrutura do Projeto](#estrutura-do-projeto)
3. [Benefícios e Aplicações](#benefícios-e-aplicações)
4. [Configuração Rápida](#configuração-rápida)
5. [Variáveis dos Módulos](#variáveis-dos-módulos)
6. [Exemplos de Uso](#exemplos-de-uso)
7. [Funcionalidades](#funcionalidades)
8. [Recursos GitHub Actions](#recursos-github-actions)
9. [Dicas e Informações](#dicas-e-informações)
10. [Referências](#referências)

---

## Introdução

O **ECS Base Infra** automatiza o provisionamento de ambientes AWS prontos para aplicações containerizadas, cobrindo desde a criação de rede e balanceamento de carga até o deploy do serviço ECS, autoscaling e integração com logs. O projeto foi desenhado para trazer agilidade, padronização e robustez aos ambientes de APIs.

---

## Estrutura do Projeto

```
/infra-base
│
├── ecs_app/                  # Módulo: Deploy de aplicações ECS
│   ├── main.tf
│   └── variables.tf
│
├── ecs_infra/                # Módulo: Infraestrutura (rede, ALB, cluster, autoscaling)
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
│
├── examples/                 # Exemplo de uso dos módulos
│   └── ecs_api/
│       ├── ecs_app.tf
│       └── ecs_infra.tf
│
├── modules/                  # Implementação dos módulos reutilizáveis
│   ├── ecs_app/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── ecs_infra/
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
│
└── README.md                 # Documentação do projeto
```

---

## Benefícios e Aplicações

- **Implantação acelerada:** Permite subir rapidamente APIs containerizadas no ECS Fargate.
- **Provisionamento completo:** Automatiza desde a rede até logs, balanceador de carga e escalonamento.
- **Padronização e economia:** Garante ambientes previsíveis, seguros e otimizados para múltiplos projetos.
- **Redução de esforço operacional:** Facilita a manutenção e o ciclo de vida da infraestrutura.

---

## Configuração Rápida

### Pré-requisitos

- [Terraform >= 1.0](https://www.terraform.io/downloads.html)
- AWS CLI configurado com permissões

### Passos

1. Clone o repositório e acesse o exemplo:
   ```bash
   git clone https://github.com/sua-org/infra-base.git
   cd infra-base/examples/ecs_api
   ```

2. Ajuste `ecs_app.tf` e `ecs_infra.tf` conforme seu ambiente.

3. Execute:
   ```bash
   terraform init
   terraform validate
   terraform apply
   ```

---

## Variáveis dos Módulos

### Módulo `ecs_app`

| Variável              | Descrição                                                                                  | Tipo         | Exemplo/Default           |
|-----------------------|--------------------------------------------------------------------------------------------|--------------|---------------------------|
| aws_region            | Região AWS para criação dos recursos                                                       | string       | "us-east-1"               |
| project_name          | Nome do projeto, usado na nomeação de recursos                                             | string       | "meu-projeto"             |
| cpu                   | CPU reservada para a task ECS (unidades)                                                   | string       | "256", "512", "1024"      |
| memory                | Memória reservada para a task ECS (MB)                                                     | string       | "512", "1024"             |
| container_port        | Porta exposta pelo container                                                               | number       | 8080                      |
| desired_count         | Quantidade desejada de tasks ECS                                                           | number       | 2                         |
| capacity_provider     | Provedor de capacidade ECS ("FARGATE" ou "FARGATE_SPOT")                                   | string       | "FARGATE"                 |
| subnet_ids            | Lista de subnets para rodar a task                                                         | list(string) | ["subnet-abc","subnet-def"]|
| security_group_id     | Security group do serviço ECS                                                              | string       | "sg-0123456789abcdef0"    |
| cluster_id            | ID/ARN do ECS Cluster                                                                      | string       | "arn:aws:ecs:..."         |
| target_group_arn      | ARN do Target Group do ALB                                                                 | string       | "arn:aws:elasticload..."  |
| image                 | URI da imagem Docker na ECR ou DockerHub                                                   | string       | "123456789012.dkr..."     |
| execution_role_arn    | ARN da role de execução ECS                                                                | string       | "arn:aws:iam::..."        |

### Módulo `ecs_infra`

| Variável                        | Descrição                                                                        | Tipo         | Exemplo/Default           |
|---------------------------------|----------------------------------------------------------------------------------|--------------|---------------------------|
| aws_region                      | Região AWS                                                                       | string       | "us-east-1"               |
| project_name                    | Nome base do projeto                                                             | string       | "meu-projeto"             |
| vpc_id                          | ID da VPC                                                                        | string       | "vpc-0a1b2c..."           |
| subnet_ids                      | Lista de subnets públicas                                                        | list(string) | ["subnet-abc","subnet-def"]|
| container_port                  | Porta exposta pelo container                                                     | number       | 8080                      |
| health_check_path               | Caminho HTTP para health check do ALB                                            | string       | "/health"                 |
| health_check_interval           | Intervalo entre checks (segundos)                                                | number       | 30                        |
| health_check_timeout            | Timeout do health check (segundos)                                               | number       | 5                         |
| health_check_healthy_threshold  | Nº de checks OK seguidos para considerar saudável                                | number       | 3                         |
| unhealthy_threshold             | Nº de checks falhos seguidos para considerar não saudável                        | number       | 2                         |
| min_capacity                    | Mínimo de tasks no ECS service                                                   | number       | 2                         |
| max_capacity                    | Máximo de tasks no ECS service                                                   | number       | 4                         |
| cpu_target_value                | Percentual de CPU para acionar autoscaling                                       | number       | 75.0                      |
| schedule_down_cron              | Cron para escala down                                                            | string       | "cron(0 18 * * ? *)"      |
| schedule_down_min_capacity      | Min capacity para escala down                                                    | number       | 0                         |
| schedule_down_max_capacity      | Max capacity para escala down                                                    | number       | 0                         |
| schedule_up_cron                | Cron para escala up                                                              | string       | "cron(0 12 * * ? *)"      |
| schedule_up_min_capacity        | Min capacity para escala up                                                      | number       | 2                         |
| schedule_up_max_capacity        | Max capacity para escala up                                                      | number       | 4                         |

---

## Exemplos de Uso

### Módulo `ecs_app`
```hcl
module "ecs_app" {
  source = "../../ecs_app"
  aws_region   = "us-east-1"
  project_name = "my-ecs-project"
  cpu            = "512"
  memory         = "1024"
  container_port = 8080
  desired_count  = 3
  capacity_provider = "FARGATE"
  subnet_ids        = ["subnet-0123456789abcdef0", "subnet-0fedcba9876543210"]
  security_group_id = "sg-0a1b2c3d4e5f6g7h"
  cluster_id        = "arn:aws:ecs:us-east-1:123456789012:cluster/my-cluster"
  target_group_arn  = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/my-target-group/abcdef1234567890"
  image              = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-app-image"
  execution_role_arn = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"
}
```

### Módulo `ecs_infra`
```hcl
module "ecs_infra" {
  source       = "../../ecs_infra"
  aws_region     = "us-east-1"
  project_name   = "my-ecs-project"
  container_port = 8080
  vpc_id         = "vpc-0a1b2c3d4e5f6g7h"
  subnet_ids     = ["subnet-0123456789abcdef0", "subnet-0fedcba9876543210"]
  health_check_path               = "/health"
  health_check_interval           = 30
  health_check_timeout            = 5
  health_check_healthy_threshold  = 3
  unhealthy_threshold             = 2
  min_capacity     = 2
  max_capacity     = 6
  cpu_target_value = 70.0
  schedule_down_cron          = "cron(0 20 * * ? *)"
  schedule_down_min_capacity  = 1
  schedule_down_max_capacity  = 2
  schedule_up_cron            = "cron(0 8 * * ? *)"
  schedule_up_min_capacity    = 3
  schedule_up_max_capacity    = 5
}
```
Para exemplos completos, veja [`examples/ecs_api`](examples/ecs_api).

---

## Funcionalidades

- **Rede**: Utilização de subnets públicas já existentes.
- **Cluster ECS Fargate**: Criação e gerenciamento automatizados.
- **Application Load Balancer**: Roteamento HTTP para as tasks ECS.
- **Target Group**: Direcionamento de requests para as tasks por IP.
- **ECR Repository**: Repositório Docker integrado ao pipeline.
- **CloudWatch Logs**: Centralização dos logs das aplicações.
- **Security Groups**: Regras de acesso seguras e pré-configuradas.
- **Health Checks**: Monitoramento contínuo dos containers.
- **Auto Scaling**: Escalonamento automático por CPU ou por horário.
- **Capacity Provider**: Suporte a FARGATE e FARGATE_SPOT.

---

## Recursos GitHub Actions

Este projeto conta com um workflow de deploy totalmente automatizado via GitHub Actions, com os seguintes recursos:

- **Execução via workflow_call:** O workflow pode ser chamado por outros workflows, recebendo parâmetros por input e secrets.
- **Job de Infraestrutura:** Provisiona a infraestrutura AWS (rede, cluster, ALB, etc) usando Terraform, extraindo outputs essenciais para deploys posteriores.
- **Job de Build e Push Docker:** Realiza build da imagem Docker e publica no ECR com tag dinâmica baseada em timestamp, além de atualizar a tag `latest`.
- **Job de Deploy no ECS:** Faz o deploy da aplicação, utilizando os artefatos e recursos criados nas etapas anteriores, atualizando a aplicação no ECS Fargate.
- **Segurança:** Utilização de secrets do GitHub Actions para credenciais AWS.
- **Passagem de variáveis entre jobs:** Uso de outputs e codificação base64 dupla para transferir informações sensíveis entre jobs de forma segura.
- **Logs e Debug:** Máscara de variáveis sensíveis nos logs, comandos explícitos de debug para facilitar troubleshooting.

O workflow permite CI/CD completo e seguro, desde infraestrutura até publicação e atualização de aplicações no ECS, tudo orquestrado diretamente pelo GitHub Actions.

---

## Dicas e Informações

- Utilize arquivos `terraform.tfvars` para facilitar a gestão dos parâmetros.
- Sempre execute `terraform plan` antes de aplicar alterações.
- Use workspaces para separar ambientes (dev, qa, prod).
- Garanta que suas permissões AWS estejam corretas para evitar falhas no provisionamento.

---

## Referências

- [AWS ECS Fargate](https://docs.aws.amazon.com/pt_br/AmazonECS/latest/developerguide/AWS_Fargate.html)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Modules - AWS ECS](https://registry.terraform.io/modules/terraform-aws-modules/ecs/aws/latest)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Exemplo: ECS Fargate + ALB](https://aws.amazon.com/getting-started/hands-on/deploy-docker-containers/)

---

Contribuições são bem-vindas! Abra issues ou pull requests com sugestões ou melhorias.