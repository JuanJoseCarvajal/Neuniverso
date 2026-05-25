# Docker y NGINX — NEUNIVERSO

## Descripción

Esta carpeta contiene la configuración de Docker Compose y NGINX para el despliegue de NEUNIVERSO en producción, optimizado para Hostinger.

- `docker-compose.yml`: Orquestación de servicios (web, admin, api, db, redis, nginx)
- `nginx.conf`: Configuración de reverse proxy, SSL y redirección
- `certs/`: Certificados SSL (Let's Encrypt)

## Uso

1. Configura las variables de entorno en `.env`
2. Ejecuta `docker compose up -d` para levantar todos los servicios
3. Verifica el estado de los contenedores y logs

## Notas
- Toda la documentación y comentarios están en español
- Optimizado para VPS Hostinger y dominio neuniverso.com
