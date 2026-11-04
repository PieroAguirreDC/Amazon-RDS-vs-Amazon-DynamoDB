#!/usr/bin/env bash
# Paso 4 del tutorial: actualizar un elemento (cambia el álbum de una canción).
set -euo pipefail
aws dynamodb update-item --table-name Music \
  --key '{"Artist": {"S": "The Acme Band"}, "SongTitle": {"S": "Look Out, World"}}' \
  --update-expression "SET AlbumTitle = :nuevo" \
  --expression-attribute-values '{":nuevo": {"S": "Updated Album Title"}}' \
  --return-values ALL_NEW
