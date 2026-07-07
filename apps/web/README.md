# NEUNIVERSO Web App

Aplicación web de Next.js para NEUNIVERSO, preparada para despliegue en Hostinger.

## Desarrollo local

Ejecuta el servidor de desarrollo con:

```bash
pnpm dev
```

Abre http://localhost:3000 para ver la aplicación.

## Despliegue en Hostinger

El despliegue de esta app debe seguir la guía de Hostinger incluida en [../../infraestructura/hostinger/DEPLOYMENT.md](../../infraestructura/hostinger/DEPLOYMENT.md).

Pasos principales:

1. Construir la aplicación con los comandos definidos en la documentación de despliegue.
2. Configurar las variables de entorno necesarias para producción.
3. Publicar la build resultante siguiendo el flujo recomendado para Hostinger.

Para más contexto sobre arquitectura y despliegue, consulta la documentación del monorepo en la raíz del proyecto.
