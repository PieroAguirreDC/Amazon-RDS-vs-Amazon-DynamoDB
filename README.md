# AWS RDS vs Amazon DynamoDB

Dos casos oficiales de AWS desplegados con Terraform, uno por servicio.

| Carpeta | Servicio | Caso oficial | Responsable |
|---|---|---|---|
| `rds-web/` | Amazon RDS | [Create a web server and an Amazon RDS DB instance](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/TUT_WebAppWithRDS.html) | Integrante 1 (Piero) |
| `dynamodb-tienda/` | Amazon DynamoDB | [Using DynamoDB as a data store for an online shop](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/data-modeling-online-shop.html) | Integrante 2 |

## Ramas

| Rama | Uso |
|---|---|
| `main` | Versión final entregada |
| `develop` | Integración; desde aquí se despliega |
| `feature/rds-web`, `feature/dynamodb-tienda` | Trabajo de cada integrante, entra a `develop` por Pull Request |

## Uso

En cada carpeta: `terraform init` → `terraform apply` → capturas → `terraform destroy`.
El despliegue es solo para las evidencias del informe: todo se destruye al terminar.