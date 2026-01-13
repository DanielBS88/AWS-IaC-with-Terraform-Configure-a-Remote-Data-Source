Terraform Remote State Lab – Documentação Passo a Passo

Este documento registra todas as etapas para concluir o lab AWS IaC with Terraform: Configure a Remote Data Source, já considerando as correções necessárias (uso do provider AWS v6 para compatibilidade com o state remoto).

1. Objetivo do Lab

Criar uma instância EC2

Reutilizar infraestrutura existente (VPC, Subnet e Security Group)

Consumir dados via terraform_remote_state (state remoto em S3)

Não modificar a Landing Zone (read-only)

2. Premissas e Restrições

Backend local (não definir backend no código)

Terraform >= 1.5.7

Provider AWS compatível com o state remoto (v6)

Nenhum local-exec, prevent_destroy ou IDs hardcoded

Variáveis somente em variables.tf

Valores somente em terraform.tfvars

Outputs somente em outputs.tf

3. Estrutura Final do Projeto
terraform-remote-state-lab/
├── compute.tf
├── data.tf
├── variables.tf
├── terraform.tfvars
├── versions.tf
├── outputs.tf
├── .gitignore
4. Criação do Diretório e Arquivos
mkdir terraform-remote-state-lab
cd terraform-remote-state-lab


touch variables.tf terraform.tfvars data.tf compute.tf versions.tf outputs.tf .gitignore
5. versions.tf (Com Correção do Provider)

Motivo: o state remoto foi criado com um provider AWS mais novo. Terraform não permite downgrade de provider ao ler um state existente.

terraform {
  required_version = ">= 1.5.7"


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
6. variables.tf

Define todas as variáveis com type e description.

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
}


variable "project_id" {
  description = "Project identifier used for tagging resources"
  type        = string
}


variable "state_bucket" {
  description = "S3 bucket name where the remote Terraform state is stored"
  type        = string
}


variable "state_key" {
  description = "S3 key path to the remote Terraform state file"
  type        = string
}
7. terraform.tfvars

Valores fornecidos pela plataforma.

aws_region  = "us-east-1"
project_id = "cmtr-k5vl9gpq"


state_bucket = "cmtr-k5vl9gpq-tf-state-1768333470"
state_key    = "infra.tfstate"
8. data.tf – Remote State

Configuração do terraform_remote_state para ler outputs da Landing Zone.

data "terraform_remote_state" "base_infra" {
  backend = "s3"


  config = {
    bucket = var.state_bucket
    key    = var.state_key
    region = var.aws_region
  }
}
9. compute.tf – EC2 Usando Remote State

A instância EC2 utiliza exclusivamente dados vindos do state remoto.

resource "aws_instance" "ec2" {
  ami           = "ami-0a3c3a20c09d6f377" # Amazon Linux 2023 (us-east-1)
  instance_type = "t2.micro"


  subnet_id = data.terraform_remote_state.base_infra.outputs.public_subnet_id


  vpc_security_group_ids = [
    data.terraform_remote_state.base_infra.outputs.security_group_id
  ]


  tags = {
    Terraform = "true"
    Project   = var.project_id
  }
}
10. outputs.tf
output "ec2_instance_id" {
  description = "ID of the EC2 instance created"
  value       = aws_instance.ec2.id
}
11. .gitignore

Evita envio de arquivos pesados e sensíveis ao repositório.

.terraform/
*.tfstate
*.tfstate.backup
.terraform.lock.hcl
crash.log
12. Inicialização (Com Upgrade)

Correção aplicada: uso do -upgrade para alinhar o provider com o state remoto.

terraform init -upgrade
13. Formatação e Validação
terraform fmt
terraform validate
14. Planejamento e Deploy
terraform plan
terraform apply
15. Validação do Lab (Checklist)

Arquivos obrigatórios existem

terraform_remote_state.base_infra configurado

Subnet e Security Group vindos do state remoto

Nenhum ID hardcoded

Tags obrigatórias presentes

Provider compatível com o state remoto

16. Git – Versionamento
git init
git branch -M main
git add .
git commit -m "Terraform: EC2 using remote state (AWS provider v6)"
17. Conclusão

Este lab demonstra um cenário real de mercado, onde:

Infraestrutura base é compartilhada

Times consomem dados via remote state

Compatibilidade de provider é crítica

A correção do provider para AWS v6 foi essencial para garantir a leitura correta do state remoto.
