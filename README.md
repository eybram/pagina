# Broken Pocket

Proyecto académico de Base de Datos II orientado a automatizar procesos comerciales de una tienda ficticia.

## Enfoque general

Este sistema sigue un enfoque Database First:

- SQL Server concentra la lógica principal del negocio.
- El backend actúa como capa de integración entre la interfaz y la base de datos.
- El frontend se limita a mostrar información y capturar acciones del usuario.

## Tecnologías principales

- Frontend: React + Vite
- Backend: Node.js + Express + mssql
- Base de datos: Microsoft SQL Server

## Estructura del repositorio

```text
backend/      # API REST y acceso a SQL Server
frontend/     # aplicación web React/Vite
sql/          # scripts de base de datos
docs/         # documentación oficial del proyecto
```

## Documentación oficial

La referencia principal del proyecto está en:

- [docs/README.md](docs/README.md)
- [docs/dev-plan/Project-requirements.md](docs/dev-plan/Project-requirements.md)
- [docs/dev-plan/Architecture.md](docs/dev-plan/Architecture.md)
- [docs/dev-plan/Coding-guidelines.md](docs/dev-plan/Coding-guidelines.md)
- [docs/dev-plan/Implementation-Plan.md](docs/dev-plan/Implementation-Plan.md)
- [docs/dev-plan/Decisions-Log.md](docs/dev-plan/Decisions-Log.md)

## Ejecución rápida

- Backend: `npm install` y `npm run dev` dentro de la carpeta backend.
- Frontend: `npm install` y `npm run dev` dentro de la carpeta frontend.
- SQL: ejecutar los scripts de la carpeta sql en el orden indicado en [sql/README.md](sql/README.md).

## Estado del proyecto

El proyecto sigue en desarrollo, con la documentación y la estructura base alineadas con las nuevas directrices académicas.
- subido en github
