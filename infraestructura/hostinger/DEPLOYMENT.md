# Guía de Deployment en Hostinger — NEUNIVERSO

Despliegue directo sin Docker. Usa Node.js, pnpm, PM2 y NGINX.

## Requisitos
- VPS Hostinger (Ubuntu 22.04+ recomendado)
- Node.js >= 20 (instálalo con `nvm` o del repositorio oficial)
- pnpm (`npm install -g pnpm`)
- PM2 (`npm install -g pm2`)
- NGINX (para proxy frontal)
- Dominio configurado

## Pasos principales

### 1. Preparar el servidor

```bash
# Actualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar Node.js (alternativa: usar nvm)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Instalar pnpm
npm install -g pnpm

# Instalar PM2
npm install -g pm2

# Instalar NGINX
sudo apt install -y nginx
```

### 2. Clonar y configurar el repositorio

```bash
cd /home/tu_usuario
git clone https://github.com/tu-org/neuniverso.git
cd neuniverso
cp .env.example .env
# Edita .env y asegúrate de que NODE_ENV=production y NEXT_PUBLIC_APP_URL=https://tu-dominio.com
```

### 3. Instalar dependencias y construir

```bash
pnpm install
pnpm --dir apps/web build
```

### 4. Iniciar la app con PM2

```bash
# Desde la raíz del repositorio
./scripts/deploy-hostinger.sh
```

O manualmente:

```bash
cd apps/web
pm2 start "pnpm start" --name neuniverso
pm2 save
```

Para que PM2 inicie automáticamente al reiniciar el servidor:

```bash
pm2 startup
# (Copia y ejecuta el comando que te devuelve)
pm2 save
```

### 5. Configurar NGINX como proxy frontal

```bash
# Ejecuta el script de configuración (requiere sudo)
sudo bash scripts/setup-nginx.sh tu-dominio.com
```

O configura manualmente en `/etc/nginx/sites-available/tu-dominio.com`:

```nginx
upstream neuniverso_app {
    server localhost:3000;
}

server {
    listen 80;
    server_name tu-dominio.com www.tu-dominio.com;

    location / {
        proxy_pass http://neuniverso_app;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Luego:

```bash
sudo ln -s /etc/nginx/sites-available/tu-dominio.com /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### 6. Configurar HTTPS con Let's Encrypt (recomendado)

```bash
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d tu-dominio.com -d www.tu-dominio.com
```

Esto configura HTTPS automáticamente y renueva cada 90 días.

### 7. Configurar DNS en Hostinger

En el panel de control de Hostinger:
- Ve a **Manage DNS records**
- Agrega o edita:
  - Tipo `A`, Nombre `@`, Valor: `IP_PUBLICA_DEL_VPS`
  - Tipo `A`, Nombre `www`, Valor: `IP_PUBLICA_DEL_VPS`
- Espera 5-15 minutos para propagación

## Monitoreo y mantenimiento

### Ver logs en vivo
```bash
pm2 logs neuniverso
```

### Reiniciar la app
```bash
pm2 restart neuniverso
```

### Ver estado
```bash
pm2 status
```

### Detener
```bash
pm2 stop neuniverso
```

## Automatización (opcional)

Usar systemd en lugar de PM2 (más directo):

```bash
# Copiar archivo de servicio
sudo cp scripts/neuniverso.service /etc/systemd/system/

# Editar rutas de usuario
sudo nano /etc/systemd/system/neuniverso.service

# Habilitar y arrancar
sudo systemctl daemon-reload
sudo systemctl enable neuniverso
sudo systemctl start neuniverso

# Ver estado
sudo systemctl status neuniverso
```

## Troubleshooting

### La app no responde
```bash
pm2 logs neuniverso
```

### NGINX devuelve 502 Bad Gateway
- Verifica que la app está corriendo: `pm2 list`
- Revisa logs de NGINX: `sudo tail -f /var/log/nginx/error.log`

### Certificado SSL no renueva
```bash
sudo certbot renew --dry-run
sudo systemctl restart nginx
```

---

**Toda la experiencia y documentación debe estar en español.**

