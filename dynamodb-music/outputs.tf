output "tabla" {
  description = "Nombre de la tabla"
  value       = aws_dynamodb_table.music.name
}

output "elementos_cargados" {
  description = "Cantidad de canciones escritas por Terraform"
  value       = length(aws_dynamodb_table_item.documentacion) + length(aws_dynamodb_table_item.catalogo)
}
