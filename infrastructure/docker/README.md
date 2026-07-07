# Docker y NGINX — NEUNIVERSO

## Descripción

Esta carpeta contiene la configuración de Docker Compose y NGINX para el despliegue de NEUNIVERSO en producción, optimizado para Hostinger.

- `docker-compose.yml`: Orquestación de servicios (web, admin, api, db, redis, nginx)
- `nginx.conf`: Configuración de reverse proxy, SSL y redirección
- `certs/`: Certificados SSL (Let's Encrypt)

## Uso

1. Configura las variables de entorno en `.env` desde la raíz del repositorio.
2. Ejecuta desde la carpeta `infrastructure/docker`:
   - `docker compose up --build -d`
3. Verifica el estado de los contenedores con `docker compose ps`.
4. Abre la app en el navegador en `http://localhost:3000`.

## Despliegue web

- La configuración actual está optimizada para la app web de Neuniverso.
- `apps/web/Dockerfile` construye la app usando su lockfile independiente.
- `infrastructure/docker/nginx.conf` enruta todo el tráfico a la app web.

## Notas
- Toda la documentación y comentarios están en español.
- Este despliegue incluye solo la app web y su proxy NGINX.
- Admin/API se pueden añadir más adelante cuando estén disponibles.
