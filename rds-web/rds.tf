# Paso 2 del tutorial: crear la instancia de base de datos RDS for MySQL
resource "random_password" "db" {
  length  = 20
  special = false
}

# "DB subnet group" del diagrama: subredes en 2 zonas de disponibilidad
resource "aws_db_subnet_group" "this" {
  name       = "tutorial-db-subnet-group"
  subnet_ids = data.aws_subnets.default.ids
}

resource "aws_db_instance" "mysql" {
  identifier     = "tutorial-db-instance"
  engine         = "mysql"
  engine_version = "8.4"
  instance_class = var.db_clase

  allocated_storage = 20    # lo que cubre el plan gratuito
  storage_type      = "gp2" # el tipo que usa la plantilla "Free tier" de la consola
  storage_encrypted = true

  db_name  = "sample"
  username = "tutorial_user"
  password = random_password.db.result

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false # la base NO es accesible desde internet
  multi_az               = false # demo; en producción true (copia en espera en la otra zona)

  backup_retention_period = 1 # copias automáticas diarias
  skip_final_snapshot     = true
  deletion_protection     = false
  apply_immediately       = true

  enabled_cloudwatch_logs_exports = ["error"]
}