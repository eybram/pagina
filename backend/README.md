# Backend

API REST desarrollada con Node.js y Express para conectar el frontend con Microsoft SQL Server.

## Objetivo

El backend debe servir como capa de integración y validación. La lógica de negocio principal sigue residiendo en la base de datos.

## Tecnologías

- Node.js
- Express
- mssql
- dotenv
- cors

## Estructura actual

```text
src/
  index.js
  db/
    pool.js
  routes/
  services/
```

## Responsabilidades

El backend debe:

- exponer endpoints REST
- validar solicitudes básicas
- ejecutar consultas o procedimientos almacenados
- transformar resultados en JSON
- manejar errores de forma consistente

No debe:

- duplicar reglas de negocio ya definidas en SQL Server
- calcular ventas o inventario de forma manual
- concentrar toda la lógica en JavaScript si existe una alternativa en base de datos

## Módulos actuales

- categorías
- franquicias
- órdenes
- productos

## Ejecución

```bash
npm install
npm run dev
```

## Convenciones

- usar consultas parametrizadas
- mantener los endpoints simples y coherentes
- priorizar la claridad y la mantenibilidad sobre la complejidad
