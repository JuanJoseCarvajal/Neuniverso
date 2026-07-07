# NEUNIVERSO

Base mínima para un sitio web moderno de NEUNIVERSO, preparada para arrancar desde cero y desplegarse en Hostinger sin Docker.

## Qué incluye

- Aplicación web en Next.js y React
- Despliegue directo sin Docker (Node.js + PM2 + NGINX)
- Scripts listos para Hostinger
- NGINX como proxy frontal

## Desarrollo local

```bash
pnpm install
pnpm dev
```

Accede a http://localhost:3000

## Despliegue en Hostinger (sin Docker)

1. Clona el repo en tu VPS Hostinger
2. Instala Node.js, pnpm y PM2
3. Crea `.env` a partir de `.env.example`
4. Ejecuta:

```bash
./scripts/deploy-hostinger.sh
```

5. Configura NGINX:

```bash
sudo bash scripts/setup-nginx.sh tu-dominio.com
```

6. Configura HTTPS con Let's Encrypt:

```bash
sudo certbot --nginx -d tu-dominio.com -d www.tu-dominio.com
```

## Despliegue remoto desde tu máquina local

Si quieres ejecutar el deploy desde tu PC hacia el servidor Hostinger, usa:

```bash
./scripts/hostinger-remote-deploy.sh usuario@host /ruta/remota git@github.com:tu-org/neuniverso.git
```

Este script prepara el servidor, clona/actualiza el repo y ejecuta el deploy sin Docker.

## Documentación

- [Guía completa de despliegue](infraestructura/hostinger/DEPLOYMENT.md)
- [Variables de entorno](.env.example)
