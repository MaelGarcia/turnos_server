#!/usr/bin/env bash
set -euo pipefail

########################################
# CONFIGURACIÓN
########################################

# Nombre del contenedor de Docker donde está PostgreSQL
CONTAINER_NAME="basedatos_data.1.2jemc5udh9wmudlb1gb35dw9u"

# Base de datos destino
DB_NAME="servicio_turno"

# Usuario de PostgreSQL
DB_USER="postgres"

# (Opcional) Host de PostgreSQL dentro del contenedor (normalmente "localhost")
DB_HOST="localhost"

########################################
# VALIDACIONES
########################################

if [ "$#" -ne 1 ]; then
  echo "Uso: $0 turnos_back/src/db/db.sql"
  exit 1
fi

SQL_FILE="$1"

if [ ! -f "$SQL_FILE" ]; then
  echo "Error: el archivo '$SQL_FILE' no existe."
  exit 1
fi

# Verificar que el contenedor está corriendo
if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  echo "Error: el contenedor '${CONTAINER_NAME}' no está en ejecución."
  exit 1
fi

########################################
# EJECUCIÓN
########################################

echo "Ejecutando archivo SQL '$SQL_FILE' en el contenedor '${CONTAINER_NAME}'..."
echo "Base de datos: ${DB_NAME} | Usuario: ${DB_USER}"

docker exec -i "$CONTAINER_NAME" \
  psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" \
  < "$SQL_FILE"

echo "✅ Script SQL ejecutado correctamente."
