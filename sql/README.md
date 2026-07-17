# SQL Server

La base de datos es el núcleo del proyecto Broken Pocket.

## Gestor

Microsoft SQL Server 2025 Developer Edition

## Archivos actuales

```text
caparazon.sql   # esquema principal del modelo relacional
datos.sql       # datos de prueba
init-db.sql     # creación de la base de datos
```

## Orden recomendado de ejecución

1. `init-db.sql`
2. `caparazon.sql`
3. `datos.sql`

## Objetivo de esta capa

- centralizar la información del sistema
- implementar reglas de negocio en procedimientos, funciones, vistas o triggers
- mantener la integridad referencial y transaccional

## Convenciones de nombres

- procedimientos: `sp_`
- funciones: `fn_`
- vistas: `vw_`
- triggers: `tr_`

## Regla general

Toda lógica relacionada con ventas, inventario y cálculo de datos debe priorizarse en SQL Server en lugar de trasladarla al backend o al frontend.
