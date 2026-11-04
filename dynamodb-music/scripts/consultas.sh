#!/usr/bin/env bash
# Pasos 3 a 5 del tutorial "Getting started with DynamoDB" sobre la tabla Music,
# más la comparación Query vs Scan. Para cada consulta muestra:
#   - elementos devueltos (Count) y elementos leídos (ScannedCount)
#   - capacidad consumida (lo que se cobra)
#   - tiempo total del comando
# Uso (Git Bash, dentro de dynamodb-music/):  bash scripts/consultas.sh
set -uo pipefail
TABLA=Music

# Python solo se usa para dar formato a la salida JSON del CLI.
PY=python
command -v python >/dev/null 2>&1 || PY=python3

medir() {   # medir "título" comando...
  local titulo="$1"; shift
  local inicio fin
  inicio=$(date +%s%N)
  local salida
  salida=$("$@" --return-consumed-capacity TOTAL --output json)
  fin=$(date +%s%N)
  echo "=== $titulo"
  echo "$salida" | "$PY" -c "import json,sys
d=json.load(sys.stdin)
cc=d.get('ConsumedCapacity') or {}
if 'Item' in d: print('  Encontrado:', d['Item']['Artist']['S'], '-', d['Item']['SongTitle']['S'])
else: print('  Devueltos:', d.get('Count'), '| Leidos:', d.get('ScannedCount'))
print('  Capacidad consumida:', cc.get('CapacityUnits'))" 2>/dev/null || echo "$salida"
  echo "  Tiempo del comando (incluye arranque del CLI e internet): $(( (fin - inicio) / 1000000 )) ms"
}

# Paso 3: leer UNA canción con la clave completa (Artist + SongTitle)
medir "GetItem: 'Still in Love' de The Acme Band (clave completa)" \
  aws dynamodb get-item --table-name $TABLA \
  --key '{"Artist": {"S": "The Acme Band"}, "SongTitle": {"S": "Still in Love"}}'

# Paso 5: Query por clave de partición -> todas las canciones de un artista
medir "Query: todas las canciones de 'No One You Know' (clave de partición)" \
  aws dynamodb query --table-name $TABLA \
  --key-condition-expression "Artist = :a" \
  --expression-attribute-values '{":a": {"S": "No One You Know"}}'

# Query con rango en la clave de ordenamiento
medir "Query: canciones de 'Artista 03' cuyo título empieza con 'Cancion 0'" \
  aws dynamodb query --table-name $TABLA \
  --key-condition-expression "Artist = :a AND begins_with(SongTitle, :t)" \
  --expression-attribute-values '{":a": {"S": "Artista 03"}, ":t": {"S": "Cancion 0"}}'

# Índice GenreAlbumTitle (Core components): buscar por género sin leer toda la tabla
medir "Query en el índice GenreAlbumTitle: todo el género Rock" \
  aws dynamodb query --table-name $TABLA --index-name GenreAlbumTitle \
  --key-condition-expression "Genre = :g" \
  --expression-attribute-values '{":g": {"S": "Rock"}}'

# La MISMA pregunta sin usar la clave: Scan con filtro -> lee toda la tabla
medir "Scan con filtro: género Rock SIN usar el índice (lee toda la tabla)" \
  aws dynamodb scan --table-name $TABLA \
  --filter-expression "Genre = :g" \
  --expression-attribute-values '{":g": {"S": "Rock"}}'
