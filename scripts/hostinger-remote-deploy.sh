#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 3 ]]; then
  cat <<EOF
Usage: $0 <usuario@host> <ruta_remota> <repo_git>

Ejemplo:
  $0 juan@123.45.67.89 /home/juan/neuniverso git@github.com:tu-org/neuniverso.git

Este script realiza los siguientes pasos en el servidor remoto:
- instala Node.js, pnpm y PM2 si no existen
- clona o actualiza el repositorio
- copia .env.example a .env si no existe
- instala dependencias y construye la app
- ejecuta el script de despliegue sin Docker
EOF
  exit 1
fi

REMOTE="$1"
REMOTE_DIR="$2"
REPO_URL="$3"
BRANCH="${4:-main}"

ssh "$REMOTE" bash -lc "'
set -euo pipefail
sudo apt update && sudo apt install -y curl gnupg ca-certificates nginx
if ! command -v node >/dev/null 2>&1; then
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
  sudo apt install -y nodejs
fi
if ! command -v pnpm >/dev/null 2>&1; then
  sudo npm install -g pnpm
fi
if ! command -v pm2 >/dev/null 2>&1; then
  sudo npm install -g pm2
fi
mkdir -p "$REMOTE_DIR"
cd "$REMOTE_DIR"
if [[ ! -d .git ]]; then
  git clone --branch "$BRANCH" "$REPO_URL" .
else
  git fetch origin "$BRANCH"
  git reset --hard "origin/$BRANCH"
fi
if [[ ! -f .env ]]; then
  cp .env.example .env || true
fi
pnpm install
pnpm --dir apps/web build
./scripts/deploy-hostinger.sh
'")

echo "✅ Deploy remoto iniciado en $REMOTE:$REMOTE_DIR"
echo "Revisa PM2 y NGINX en el servidor remoto."