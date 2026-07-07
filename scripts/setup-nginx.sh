#!/usr/bin/env bash
set -euo pipefail

# Script para configurar NGINX en Hostinger (sin Docker)
# Uso: bash scripts/setup-nginx.sh tu-dominio.com

DOMAIN="${1:-neuniverso.com}"
NGINX_CONF="/etc/nginx/sites-available/$DOMAIN"

echo "=== Configurando NGINX para $DOMAIN ==="

# Crear bloque de servidor
sudo tee "$NGINX_CONF" > /dev/null <<EOF
upstream neuniverso_app {
    server localhost:3000;
}

server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;

    location / {
        proxy_pass http://neuniverso_app;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_redirect off;
    }
}
EOF

# Habilitar el sitio
sudo ln -sf "$NGINX_CONF" /etc/nginx/sites-enabled/"$DOMAIN"

# Remover default si existe
sudo rm -f /etc/nginx/sites-enabled/default

# Verificar sintaxis
sudo nginx -t

# Recargar NGINX
sudo systemctl reload nginx

echo "✅ NGINX configurado correctamente para $DOMAIN"
echo "💡 Para HTTPS, configura Let's Encrypt después:
    sudo apt install certbot python3-certbot-nginx
    sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN"
