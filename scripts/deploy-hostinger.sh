#!/usr/bin/env bash
set -euo pipefail

echo "=== NEUNIVERSO Deploy Script (Sin Docker) ==="

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="$REPO_ROOT/.env"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "❌ Error: no existe el archivo .env en la raíz del repositorio."
  echo "✓ Crea .env a partir de .env.example:"
  echo "  cp .env.example .env"
  exit 1
fi

echo "✓ Archivo .env encontrado"

# Instalar dependencias
echo "📦 Instalando dependencias..."
cd "$REPO_ROOT"
pnpm install

# Construir la app
echo "🔨 Construyendo la app..."
pnpm --dir apps/web build

# Detener PM2 si ya existe
echo "🛑 Deteniendo procesos anteriores (si existen)..."
pm2 stop neuniverso 2>/dev/null || true
pm2 delete neuniverso 2>/dev/null || true

# Iniciar con PM2
echo "▶️  Iniciando app con PM2..."
cd "$REPO_ROOT/apps/web"
pm2 start "pnpm start" --name neuniverso --env "$ENV_FILE"

# Guardar estado de PM2
pm2 save

echo ""
echo "✅ Despliegue completado."
echo "📋 Estado de procesos:"
pm2 list
echo ""
echo "🔗 Accede a la app en http://localhost:3000"
echo "💡 Para ver logs: pm2 logs neuniverso"
echo "💡 Para reiniciar: pm2 restart neuniverso"
