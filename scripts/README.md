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

