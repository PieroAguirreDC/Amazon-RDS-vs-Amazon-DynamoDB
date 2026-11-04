# Como el tutorial: VPC predeterminada de la cuenta, con subredes en 2 zonas.
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = ["${var.region}a", "${var.region}b"]
  }
}

# Grupo de seguridad de la EC2 ("ec2-rds-x" en el diagrama): deja entrar HTTP desde internet
resource "aws_security_group" "ec2" {
  name        = "ec2-rds-tutorial"
  description = "Servidor web del tutorial"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP desde internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Grupo de seguridad de RDS ("rds-ec2-x" en el diagrama): MySQL SOLO desde la EC2
resource "aws_security_group" "rds" {
  name        = "rds-ec2-tutorial"
  description = "MySQL solo desde el servidor web"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "MySQL desde la EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }
}