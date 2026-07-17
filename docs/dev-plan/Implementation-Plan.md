# Broken Pocket
# Development Roadmap

Versión: 2.0

Proyecto: Semestral Base de Datos II

---

# 1. Objetivo

Este documento define el orden oficial para desarrollar Broken Pocket.

El proyecto se implementará por módulos funcionales.

Cada módulo deberá quedar completamente terminado antes de iniciar el siguiente.

Una funcionalidad se considera terminada únicamente cuando:

• existe en SQL Server

• existe en la API

• existe en el frontend

• fue probada

---

# 2. Estrategia de Desarrollo

El desarrollo seguirá la metodología:

Database First

↓

Backend

↓

Frontend

↓

Pruebas

↓

Documentación

Nunca se implementará primero la interfaz.

---

# 3. Estado Actual

## Completado

- Modelo relacional
- Scripts SQL
- Datos de prueba
- PRD
- Arquitectura

## Pendiente

- Backend
- Frontend
- API
- Dashboard
- Documentación

---

# FASE 1

## Configuración

Objetivo

Preparar el proyecto.

### SQL Server

- Crear la base de datos
- Ejecutar caparazon.sql
- Ejecutar datos.sql
- Validar restricciones

### Backend

- Crear proyecto Node
- Instalar dependencias
- Configurar Express
- Configurar mssql
- Configurar variables de entorno
- Configurar estructura modular

### Frontend

- Crear React
- Configurar Vite
- Configurar Router
- Configurar estructura de carpetas

Entregable

Proyecto ejecutándose correctamente.

---

# FASE 2

# Módulo Productos

Objetivo

Administrar productos.

## SQL

- Procedimientos
- Funciones
- Consultas
- Vistas

## Backend

- Endpoints
- Servicio
- Controlador
- Validaciones

## Frontend

- Lista
- Detalle
- Buscar
- Filtrar

## Pruebas

- Obtener productos
- Buscar
- Filtrar

Entregable

Módulo Productos terminado.

---

# FASE 3

# Módulo Categorías

## SQL

- Procedimientos
- Consultas

## Backend

CRUD

## Frontend

Administración

## Pruebas

CRUD completo

Entregable

Categorías terminadas.

---

# FASE 4

# Módulo Franquicias

SQL

Backend

Frontend

Pruebas

Entregable

Franquicias terminadas.

---

# FASE 5

# Módulo Proveedores

SQL

Backend

Frontend

Pruebas

Entregable

Proveedores terminados.

---

# FASE 6

# Módulo Empleados

SQL

Backend

Frontend

Pruebas

Entregable

Empleados terminados.

---

# FASE 7

# Módulo Clientes

SQL

Backend

Frontend

Pruebas

Entregable

Clientes terminados.

---

# FASE 8

# Módulo Ventas

Este módulo es el núcleo del sistema.

Incluye

Orden

Detalle

Checkout

Inventario

## SQL

Registrar venta

Registrar detalle

Actualizar stock

Registrar movimiento

Transacciones

Triggers

## Backend

Checkout

Clientes

Órdenes

## Frontend

Carrito

Checkout

Resumen

## Pruebas

Venta completa

Stock

Inventario

Entregable

Proceso completo de venta funcionando.

---

# FASE 9

# Dashboard

Objetivo

Implementar reportes.

## SQL

Vistas

Funciones

Consultas

## Backend

API Dashboard

## Frontend

KPIs

Gráficos

Tablas

Entregable

Dashboard funcional.

---

# FASE 10

# Seguridad

Login

Roles

Sesiones

Pruebas

Entregable

Sistema protegido.

---

# FASE 11

# Integración

Verificar

Frontend

↓

Backend

↓

SQL Server

Realizar pruebas completas.

---

# FASE 12

# Documentación

README

Manual Técnico

Manual Usuario

Diagramas UML

Capturas

Entrega Final

---

# Definition of Done

Cada módulo deberá cumplir:

☐ SQL implementado

☐ Procedimientos creados

☐ API funcional

☐ Frontend funcional

☐ Validaciones implementadas

☐ Manejo de errores

☐ Pruebas realizadas

☐ Documentación actualizada

---

# Prioridad

1

Ventas

Inventario

Productos

2

Clientes

Categorías

Franquicias

3

Dashboard

Administración

Seguridad

---

# Reglas para Codex

Antes de comenzar cualquier tarea el agente deberá verificar:

1.

Que la funcionalidad exista en el PRD.

2.

Que la implementación siga ARCHITECTURE.md.

3.

Que no se modifique el modelo de datos.

4.

Que cada módulo quede completamente terminado antes de iniciar el siguiente.

5.

Que toda lógica relacionada con persistencia de datos permanezca en SQL Server.

6.

Que toda nueva funcionalidad incluya:

SQL

↓

Backend

↓

Frontend

↓

Pruebas

---

# Objetivo Final

Broken Pocket deberá convertirse en un sistema integral de gestión comercial para una tienda de videojuegos, implementando correctamente los conceptos de Base de Datos II mediante una arquitectura modular, escalable y mantenible.
