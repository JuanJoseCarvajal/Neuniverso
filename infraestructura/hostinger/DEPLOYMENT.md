# Guía de Deployment en Hostinger — NEUNIVERSO

Esta guía describe el proceso recomendado para desplegar NEUNIVERSO en Hostinger (VPS/Cloud).

## Requisitos
- VPS Hostinger (Ubuntu 22.04+ recomendado)
- Docker y Docker Compose
- Dominio configurado (neuniverso.com)
- Acceso SSH

## Pasos principales

1. **Preparar el servidor**
   - Actualiza el sistema: `sudo apt update && sudo apt upgrade -y`
   - Instala Docker: [Guía oficial Docker](https://docs.docker.com/engine/install/ubuntu/)
   - Instala Docker Compose: [Guía oficial Compose](https://docs.docker.com/compose/install/)
   - Configura usuario y firewall (UFW)

2. **Clonar el repositorio**
   - `git clone https://github.com/tu-org/neuniverso.git`
   - `cd neuniverso`

3. **Configurar variables de entorno**
   - Copia `.env.example` a `.env` y completa los valores

4. **Configurar Docker y NGINX**
   - Edita los archivos en `/infrastructure/docker` y `/infrastructure/hostinger` según tu entorno
   - Configura certificados SSL con Let's Encrypt

5. **Desplegar servicios**
   - `docker compose up -d`
   - Verifica logs y estado de los contenedores

6. **Automatización y monitoreo**
   - Configura PM2 para procesos Node.js si aplica
   - Configura monitoreo y backups

## Seguridad y optimización
- Habilita HTTPS y redirección forzada
- Usa variables de entorno seguras
- Aplica hardening básico al servidor
- Optimiza Node.js y PostgreSQL para producción

## Troubleshooting
- Revisa logs de Docker y NGINX
- Verifica puertos y firewall
- Consulta la documentación oficial de cada servicio

---

**Toda la experiencia y documentación debe estar en español.**
