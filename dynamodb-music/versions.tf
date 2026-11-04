
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
