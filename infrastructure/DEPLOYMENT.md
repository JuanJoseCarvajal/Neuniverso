# NEUNIVERSO - Guía de Despliegue en Hostinger

## 📋 Requisitos Previos

- VPS en Hostinger (o similar) con Ubuntu 22.04 LTS
- Mínimo: 4GB RAM, 2 vCPU (recomendado: 8GB RAM, 4 vCPU)
- Acceso SSH a la raíz
- Dominio `neuniverso.com` apuntando a la IP del VPS

## 🚀 Instalación Rápida (Recomendado)

### 1. Conectar al VPS
```bash
ssh root@tu-ip-vps
```

### 2. Instalar Docker
```bash
curl -fsSL https://get.docker.com | sh
```

### 3. Ejecutar Despliegue Automático
```bash
cd $HOME
git clone -b deployment/hostinger-setup https://github.com/JuanJoseCarvajal/Neuniverso.git
cd Neuniverso
sudo bash scripts/deploy-hostinger.sh main deploy
```

**⏱️ Tiempo total: 10-15 minutos**

El script hará automáticamente:
- ✅ Validar Docker está instalado
- ✅ Clonar/actualizar repositorio
- ✅ Crear `.env` con contraseñas seguras
- ✅ Crear estructura de directorios
- ✅ Iniciar contenedores (PostgreSQL, Redis, Next.js, NGINX)
- ✅ Solicitar certificado SSL con Let's Encrypt
- ✅ Configurar renovación automática de SSL
- ✅ Configurar backups automáticos (2 AM)
- ✅ Verificar que todo funciona

---

## 🔧 Configuración Manual (Si prefieres)

### 1. Instalar Docker
```bash
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER
```

### 2. Clonar Repositorio
```bash
cd $HOME
git clone -b deployment/hostinger-setup https://github.com/JuanJoseCarvajal/Neuniverso.git
cd Neuniverso
```

### 3. Crear Archivo `.env`
```bash
cp infrastructure/.env.example infrastructure/.env

# Generar secrets seguros:
openssl rand -base64 32  # Para NEXTAUTH_SECRET
openssl rand -base64 16  # Para DB_PASSWORD
openssl rand -base64 16  # Para REDIS_PASSWORD

# Editar archivo:
nano infrastructure/.env
```

### 4. Crear Directorios
```bash
mkdir -p infrastructure/certbot/{conf,www}
mkdir -p backups
chmod -R 755 infrastructure/certbot backups
```

### 5. Iniciar Contenedores
```bash
cd infrastructure
docker compose up -d
```

### 6. Solicitar SSL
```bash
docker compose exec certbot certbot certonly \
  --webroot -w /var/www/certbot \
  -d neuniverso.com -d www.neuniverso.com \
  --email jjcmili@hotmail.com \
  --agree-tos
```

### 7. Recargar NGINX
```bash
docker compose exec nginx nginx -s reload
```

---

## 🌐 Configurar DNS

En tu registrador de dominio (GoDaddy, Namecheap, etc):

```
Tipo    | Host              | Valor
--------|-------------------|----------
A       | neuniverso.com    | [IP del VPS]
CNAME   | www.neuniverso.com| neuniverso.com
```

Espera 24-48 horas para propagación.

---

## 📝 Post-Configuración Importante

### 1. Actualizar `.env` con APIs
```bash
nano infrastructure/.env
```

Agregar:
- `STRIPE_SECRET_KEY` - Para pagos
- `OPENAI_API_KEY` - Para IA
- `SMTP_*` - Para envío de emails

### 2. Verificar Logs
```bash
cd $REPO_DIR
docker compose -f infrastructure/docker-compose.yml logs -f web
```

### 3. Acceder a la Web
```
https://neuniverso.com
```

---

## 🔍 Comandos Útiles

### Ver estado de servicios
```bash
cd ~/neuniverso
docker compose -f infrastructure/docker-compose.yml ps
```

### Ver logs en tiempo real
```bash
docker compose -f infrastructure/docker-compose.yml logs -f
docker compose -f infrastructure/docker-compose.yml logs -f web  # Solo web
```

### Acceder a base de datos
```bash
docker compose -f infrastructure/docker-compose.yml exec db \
  psql -U neuniverso -d neuniverso_db
```

### Reiniciar servicios
```bash
docker compose -f infrastructure/docker-compose.yml restart
docker compose -f infrastructure/docker-compose.yml restart web  # Solo web
```

### Detener servicios
```bash
docker compose -f infrastructure/docker-compose.yml down
```

### Backup manual
```bash
bash ~/neuniverso/scripts/backup.sh
```

### Listar backups
```bash
ls -lah ~/neuniverso/backups/
```

---

## 🔐 Seguridad Recomendada

### 1. SSH Hardening
```bash
# Editar configuración SSH
sudo nano /etc/ssh/sshd_config

# Cambios recomendados:
# Port 2222 (cambiar puerto por defecto)
# PermitRootLogin no
# PasswordAuthentication no
# PubkeyAuthentication yes

sudo systemctl restart sshd
```

### 2. Firewall
```bash
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 2222/tcp  # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
```

### 3. Backup Remoto (Opcional)
Descomentar en `scripts/backup.sh`:
```bash
# aws s3 cp "$BACKUP_FILE" "s3://my-bucket/backups/"
```

---

## ⚠️ Troubleshooting

### Los contenedores no inician
```bash
# Ver error específico
docker compose -f infrastructure/docker-compose.yml logs

# Rebuild
docker compose -f infrastructure/docker-compose.yml build --no-cache
```

### SSL no se renueva
```bash
# Verificar certificados
ls -la infrastructure/certbot/conf/live/

# Renovar manualmente
docker compose -f infrastructure/docker-compose.yml exec certbot \
  certbot renew --dry-run
```

### Web app devuelve 502
```bash
# Verificar que web esté corriendo
docker compose -f infrastructure/docker-compose.yml ps web

# Ver logs de Next.js
docker compose -f infrastructure/docker-compose.yml logs web

# Reiniciar
docker compose -f infrastructure/docker-compose.yml restart web
```

### Base de datos no conecta
```bash
# Verificar BD
docker compose -f infrastructure/docker-compose.yml exec db \
  psql -U neuniverso -d neuniverso_db -c "SELECT 1;"

# Ver logs
docker compose -f infrastructure/docker-compose.yml logs db
```

### Certificado SSL falla
```bash
# Ver certificados actuales
docker compose -f infrastructure/docker-compose.yml exec certbot \
  certbot certificates

# Solicitar nuevo
docker compose -f infrastructure/docker-compose.yml exec certbot \
  certbot certonly --webroot -w /var/www/certbot \
  -d neuniverso.com -d www.neuniverso.com
```

---

## 📊 Monitoreo

### Ver uso de recursos
```bash
docker stats

# O más detallado:
watch -n 1 'docker stats --no-stream'
```

### Ver espacio en disco
```bash
df -h
docker system df
```

### Limpiar recursos no usados
```bash
docker system prune -a --volumes
```

---

## 🔄 Actualizaciones

### Actualizar aplicación
```bash
cd ~/neuniverso
git pull origin deployment/hostinger-setup
docker compose -f infrastructure/docker-compose.yml build --no-cache web
docker compose -f infrastructure/docker-compose.yml up -d web
```

### Actualizar Docker
```bash
sudo apt update && sudo apt upgrade -y
sudo systemctl restart docker
```

---

## 📞 Soporte

Para problemas:
1. Revisa los logs: `docker compose logs -f`
2. Verifica variables en `.env`
3. Consulta la documentación oficial de Docker
4. Abre un issue en GitHub

---

**¡Tu aplicación NEUNIVERSO está lista en producción!** 🚀
