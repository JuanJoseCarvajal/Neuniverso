#!/bin/bash
# Backup Script for NEUNIVERSO Database
# Ejecutado automáticamente diariamente a las 2 AM

BACKUP_DIR="${HOME}/neuniverso/backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/db_backup_${DATE}.sql"
DOCKER_COMPOSE_FILE="${HOME}/neuniverso/infrastructure/docker-compose.yml"

# Crear directorio si no existe
mkdir -p "$BACKUP_DIR"

echo "📦 Iniciando backup de base de datos..."
echo "   Archivo: $BACKUP_FILE"
echo "   Hora: $(date)"

# Hacer backup
docker compose -f "$DOCKER_COMPOSE_FILE" exec -T db \
    pg_dump -U neuniverso neuniverso_db > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    # Comprimir backup
    gzip "$BACKUP_FILE"
    BACKUP_FILE="${BACKUP_FILE}.gz"
    
    SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo "✅ Backup completado exitosamente"
    echo "   Tamaño: $SIZE"
    echo "   Archivo: $BACKUP_FILE"
    
    # Mantener solo los últimos 7 días
    find "$BACKUP_DIR" -name "db_backup_*.sql.gz" -mtime +7 -delete
    echo "🗑️  Backups antiguos (>7 días) eliminados"
else
    echo "❌ Error durante el backup"
    exit 1
fi

# Opcional: Enviar a respaldo remoto (descomentar si usas)
# aws s3 cp "$BACKUP_FILE" "s3://my-bucket/backups/"
