output "pagina_web" {
  description = "Abrir en el navegador (esperar 2-3 min tras el apply)"
  value       = "http://${aws_instance.web.public_dns}/SamplePage.php"
}

output "rds_endpoint" {
  description = "Dirección de la base RDS (solo accesible desde la EC2)"
  value       = aws_db_instance.mysql.address
}