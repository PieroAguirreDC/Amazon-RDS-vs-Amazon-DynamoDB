# AWS RDS vs Amazon DynamoDB

Dos casos oficiales de AWS desplegados con Terraform, uno por servicio.

| Carpeta | Servicio | Caso oficial | Responsable |
|---|---|---|---|
| `rds-web/` | Amazon RDS | [Create a web server and an Amazon RDS DB instance](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/TUT_WebAppWithRDS.html) | Integrante 1 (Piero) |
| `dynamodb-music/` | Amazon DynamoDB | [Getting started with DynamoDB](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GettingStartedDynamoDB.html) (tabla Music) | Integrante 2 |

## Ramas

| Rama | Uso |
|---|---|
| `main` | Versión final entregada |
| `develop` | Integración; desde aquí se despliega |
| `feature/rds-web`, `feature/dynamodb-music` | Trabajo de cada integrante, entra a `develop` por Pull Request |

## Uso

En cada carpeta: `terraform init` → `terraform apply` → capturas → `terraform destroy`.
El despliegue es solo para las evidencias del informe: todo se destruye al terminar.
