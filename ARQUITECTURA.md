# Arquitectura del Monorepo — NEUNIVERSO

## Estructura principal

- `/apps` — Aplicaciones principales (web, admin, docs)
- `/packages` — Paquetes compartidos (ui, config, design-tokens, auth, database, analytics, ai)
- `/services` — Microservicios (api, realtime, oracle, payments, notifications)
- `/infrastructure` — Infraestructura y despliegue (docker, hostinger, monitoring, deploy)
- `/scripts` — Automatización y utilidades

## Principios de arquitectura
- Modularidad y escalabilidad
- Separación de responsabilidades
- Uso de TypeScript strict en todo el stack
- Experiencia y documentación en español
- Seguridad y performance enterprise-grade
- Optimización para despliegue en Hostinger

## Stack tecnológico
- **Frontend:** Next.js, React, Tailwind, Three.js, Zustand, TanStack Query, shadcn/ui
- **Backend:** NestJS, PostgreSQL, Prisma, Redis, WebSockets, Stripe
- **Infraestructura:** Docker, NGINX, PM2, CI/CD, GitHub Actions, Hostinger

## Decisiones técnicas
- Monorepo gestionado con Turborepo y pnpm workspaces
- Configuración centralizada de TypeScript y linters
- Uso de design system propio y tokens de diseño
- Arquitectura orientada a eventos y microservicios
- Seguridad siguiendo OWASP y mejores prácticas

---

Para detalles adicionales, consulta la documentación en cada carpeta y el README principal.