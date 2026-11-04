# Paso 2 del tutorial: escribir datos.
# 1) Las 4 canciones exactas de la página "Core components"
locals {
  canciones_documentacion = {
    "spot" = {
      Artist = { S = "No One You Know" }, SongTitle = { S = "My Dog Spot" }, AlbumTitle = { S = "Hey Now" }
      Price  = { N = "1.98" }, Genre = { S = "Country" }, CriticRating = { N = "8.4" }
    }
    "road" = {
      Artist = { S = "No One You Know" }, SongTitle = { S = "Somewhere Down The Road" }, AlbumTitle = { S = "Somewhat Famous" }
      Genre  = { S = "Country" }, CriticRating = { N = "8.4" }, Year = { N = "1984" }
    }
    "love" = {
      Artist = { S = "The Acme Band" }, SongTitle = { S = "Still in Love" }, AlbumTitle = { S = "The Buck Starts Here" }
      Price  = { N = "2.47" }, Genre = { S = "Rock" }
      PromotionInfo = { M = {
        RadioStationsPlaying = { L = [{ S = "KHCR" }, { S = "KQBX" }, { S = "WTNR" }, { S = "WJJH" }] }
        TourDates            = { M = { Seattle = { S = "20150622" }, Cleveland = { S = "20150630" } } }
        Rotation             = { S = "Heavy" }
      } }
    }
    "world" = {
      Artist = { S = "The Acme Band" }, SongTitle = { S = "Look Out, World" }, AlbumTitle = { S = "The Buck Starts Here" }
      Price  = { N = "0.99" }, Genre = { S = "Rock" }
    }
  }

  # 2) Catálogo de relleno (10 artistas x 10 canciones = 100) para que se note
  #    la diferencia entre Query (va directo) y Scan (lee toda la tabla).
  generos = ["Rock", "Pop", "Jazz", "Salsa", "Cumbia"]
  catalogo = {
    for par in setproduct(range(1, 11), range(1, 11)) :
    "a${par[0]}-c${par[1]}" => {
      Artist     = { S = format("Artista %02d", par[0]) }
      SongTitle  = { S = format("Cancion %02d", par[1]) }
      AlbumTitle = { S = format("Album %02d-%d", par[0], ceil(par[1] / 5)) }
      Genre      = { S = local.generos[par[0] % 5] }
      Price      = { N = format("%.2f", 0.99 + (par[1] % 3)) }
    }
  }
}

resource "aws_dynamodb_table_item" "documentacion" {
  for_each   = local.canciones_documentacion
  table_name = aws_dynamodb_table.music.name
  hash_key   = aws_dynamodb_table.music.hash_key
  range_key  = aws_dynamodb_table.music.range_key
  item       = jsonencode(each.value)
}

resource "aws_dynamodb_table_item" "catalogo" {
  for_each   = local.catalogo
  table_name = aws_dynamodb_table.music.name
  hash_key   = aws_dynamodb_table.music.hash_key
  range_key  = aws_dynamodb_table.music.range_key
  item       = jsonencode(each.value)
}
