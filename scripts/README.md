# Scripts Automatizados — NEUNIVERSO

Scripts de despliegue y automatización para NEUNIVERSO en Hostinger (sin Docker).

## `deploy-hostinger.sh`

Despliegue completo sin Docker.

```bash
./scripts/deploy-hostinger.sh
```

Qué hace:
- Instala dependencias con pnpm
- Construye la app Next.js
- Inicia el proceso con PM2
- Guarda el estado de PM2

## `hostinger-remote-deploy.sh`

Despliegue remoto desde tu máquina local hacia el servidor Hostinger.

```bash
./scripts/hostinger-remote-deploy.sh usuario@host /ruta/remota git@github.com:tu-org/neuniverso.git
```

Qué hace:
- Prepara el servidor con Node.js, pnpm, PM2 y NGINX
- Clona o actualiza el repositorio
- Copia `.env.example` a `.env` si no existe
- Construye la app y ejecuta el deploy

## `setup-nginx.sh`

Configura NGINX como proxy frontal (requiere sudo).

```bash
sudo bash ./scripts/setup-nginx.sh tu-dominio.com
```

Qué hace:
- Crea configuración de NGINX
- Habilita el sitio
- Valida y recarga NGINX

## `neuniverso.service`

Archivo de servicio systemd (alternativa a PM2).

Instalación:
```bash
sudo cp scripts/neuniverso.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable neuniverso
sudo systemctl start neuniverso
```

---

**Nota:** Todos los scripts están configurados para despliegue directo sin Docker.

