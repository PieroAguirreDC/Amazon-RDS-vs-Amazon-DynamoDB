# Paso 1 del tutorial: crear la tabla Music.
# Clave primaria COMPUESTA: Artist (partición) + SongTitle (ordenamiento).
resource "aws_dynamodb_table" "music" {
  name         = "Music"
  billing_mode = "PAY_PER_REQUEST" # bajo demanda, igual que el tutorial
  table_class  = "STANDARD"
  hash_key     = "Artist"
  range_key    = "SongTitle"

  attribute {
    name = "Artist"
    type = "S"
  }

  attribute {
    name = "SongTitle"
    type = "S"
  }

  attribute {
    name = "Genre"
    type = "S"
  }

  attribute {
    name = "AlbumTitle"
    type = "S"
  }

  # Índice secundario global de "Core components": buscar por género y álbum
  # sin leer toda la tabla. Solo copia las claves (KEYS_ONLY), como en la documentación.
  global_secondary_index {
    name            = "GenreAlbumTitle"
    projection_type = "KEYS_ONLY"

    key_schema {
      attribute_name = "Genre"
      key_type       = "HASH"
    }

    key_schema {
      attribute_name = "AlbumTitle"
      key_type       = "RANGE"
    }
  }

  # Recomendado en el paso 1: recuperación a un punto en el tiempo (últimos 35 días)
  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }
}
