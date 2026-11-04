# Hoja de Terraform que reproduce la tabla "Music" de la documentación oficial de DynamoDB:
#  - Getting started with DynamoDB:
#    <https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GettingStartedDynamoDB.html>
#  - Core components (estructura de tabla, claves e índice GenreAlbumTitle):
#    <https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/HowItWorks.CoreComponents.html>
# Solo se usa DynamoDB: no hay Lambda, API ni red.
terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Proyecto = "dynamodb-music"
      Fuente   = "DynamoDB-Getting-Started-Music"
      Gestion  = "Terraform"
    }
  }
}

variable "region" {
  description = "Región de AWS"
  type        = string
  default     = "us-east-1"
}
