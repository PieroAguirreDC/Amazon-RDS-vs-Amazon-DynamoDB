# Hoja de Terraform que reproduce el tutorial oficial de AWS:
# "Tutorial: Create a web server and an Amazon RDS DB instance"
# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/TUT_WebAppWithRDS.html
# Mismo diagrama: EC2 con servidor web (Apache + PHP) -> RDS for MySQL en red privada.
# La diferencia es que aquí todo se crea con terraform apply en vez de clics.

terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Proyecto = "evidencia-rds-web"
      Fuente   = "AWS-RDS-WebServer-Tutorial"
      Gestion  = "Terraform"
    }
  }
}

variable "region" {
  description = "Región de AWS"
  type        = string
  default     = "us-east-1"
}

variable "db_clase" {
  description = "Clase de la instancia RDS (plan gratuito)"
  type        = string
  default     = "db.t4g.micro"
}

variable "ec2_tipo" {
  description = "Tipo de la instancia EC2 (plan gratuito)"
  type        = string
  default     = "t3.micro"
}