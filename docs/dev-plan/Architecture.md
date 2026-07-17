# Broken Pocket
# Software Architecture Document (SAD)

Versión: 1.0

---

# 1. Propósito

Este documento define la arquitectura técnica del proyecto Broken Pocket.

Su objetivo es establecer una única referencia para la implementación del sistema, garantizando que el frontend, backend y base de datos mantengan una estructura consistente durante todo el desarrollo.

Este documento complementa el Product Requirements Document (PRD).

---

# 2. Filosofía de la Arquitectura

Broken Pocket seguirá una arquitectura **Database First**.

La base de datos representa el núcleo del sistema y contiene la mayor parte de la lógica de negocio.

La aplicación web actuará como interfaz para interactuar con dicha lógica.

La arquitectura prioriza la implementación de funcionalidades de SQL Server por encima de la complejidad del frontend.

---

# 3. Arquitectura General

                React + Vite
                     │
                     │ HTTP / JSON
                     ▼
              Node.js + Express
                     │
                     │ mssql
                     ▼
      Stored Procedures / Views / Functions
                     │
                     ▼
     Microsoft SQL Server 2025 Developer Edition

---

# 4. Arquitectura por Capas

## Presentation Layer

Tecnología

- React
- Vite

Responsabilidades

- Mostrar información.
- Validar formularios.
- Consumir la API.
- Gestionar navegación.
- Manejar estados de carga.

No debe

- Ejecutar consultas SQL.
- Contener lógica de negocio.
- Calcular inventario.
- Calcular ventas.

---

## Business Layer

Tecnología

- Node.js
- Express

Responsabilidades

- Exponer la API REST.
- Validar solicitudes.
- Ejecutar procedimientos almacenados.
- Transformar resultados en JSON.
- Manejar errores.

No debe

- Calcular totales.
- Actualizar inventario manualmente.
- Modificar reglas de negocio.

---

## Data Layer

Tecnología

Microsoft SQL Server 2025 Developer Edition

Responsabilidades

- Almacenar información.
- Ejecutar procedimientos.
- Ejecutar funciones.
- Ejecutar triggers.
- Ejecutar transacciones.
- Mantener integridad.

Esta capa contiene la lógica principal del negocio.

---

# 5. Flujo Principal

Cliente

↓

Frontend

↓

API REST

↓

Stored Procedure

↓

Base de Datos

↓

Resultado

↓

JSON

↓

Frontend

---

# 6. Flujo de Compra

Cliente

↓

Catálogo

↓

Carrito

↓

Checkout

↓

POST /ordenes

↓

sp_RegistrarVenta

↓

Crear Orden

↓

Crear Detalle

↓

Actualizar Stock

↓

Registrar Movimiento

↓

Commit

↓

Respuesta

---

# 7. Organización del Proyecto

```
broken-pocket/

│

├── frontend/

├── backend/

├── sql/

├── docs/

├── README.md

├── PROJECT_REQUIREMENTS.md

├── ARCHITECTURE.md

└── IMPLEMENTATION_PLAN.md

```

---

# 8. Frontend

```
frontend/

src/

components/

pages/

layouts/

hooks/

context/

services/

assets/

styles/

router/

utils/

App.jsx

main.jsx

```

## components

Componentes reutilizables.

Ejemplos

Navbar

Footer

ProductCard

ProductGrid

SearchBar

Button

Modal

Table

---

## pages

Representan una ruta completa.

Home

Product

Cart

Checkout

Dashboard

Login

Productos

Categorias

Franquicias

Inventario

Empleados

Proveedores

---

## services

Toda llamada HTTP.

Ejemplo

productosService.js

clientesService.js

ordenesService.js

---

## context

Estados globales.

Ejemplo

AuthContext

CartContext

---

# 9. Backend

```
backend/

src/

config/

controllers/

routes/

services/

database/

middlewares/

validators/

utils/

app.js

server.js

```

---

## controllers

Reciben solicitudes HTTP.

No contienen lógica de negocio.

---

## services

Invocan procedimientos almacenados.

---

## database

Conexión SQL Server.

Pool reutilizable.

---

## routes

Define endpoints.

---

## validators

Validaciones simples.

Ejemplo

Campos requeridos.

Formato correo.

---

# 10. Base de Datos

```
sql/

caparazon.sql

datos.sql

procedimientos/

funciones/

vistas/

triggers/

consultas/

```

La carpeta SQL será la fuente oficial de todos los objetos de la base de datos.

---

# 11. Comunicación

Frontend

↓

HTTP

↓

Express

↓

mssql

↓

SQL Server

No se permitirá comunicación directa entre React y SQL Server.

---

# 12. API REST

Formato

```
GET

POST

PUT

DELETE

```

Respuesta

```
{
    success: true,
    data: ...
}
```

Errores

```
{
    success: false,
    message: ""
}
```

---

# 13. Convención de Endpoints

Productos

/api/productos

Categorias

/api/categorias

Franquicias

/api/franquicias

Clientes

/api/clientes

Ordenes

/api/ordenes

Empleados

/api/empleados

Proveedores

/api/proveedores

Dashboard

/api/dashboard

---

# 14. Convención de Archivos

Componentes React

PascalCase

```
ProductCard.jsx
```

Funciones JavaScript

camelCase

```
getProducts()
```

Variables

camelCase

```
cartItems
```

SQL

snake_case

```
sp_registrar_venta
```

---

# 15. Convención para SQL

Todos los procedimientos

```
sp_
```

Funciones

```
fn_
```

Triggers

```
tr_
```

Vistas

```
vw_
```

---

# 16. Gestión de Errores

Frontend

Mostrar mensajes amigables.

Backend

Capturar excepciones.

Registrar errores.

SQL

TRY

CATCH

ROLLBACK

---

# 17. Transacciones

Toda operación que modifique múltiples tablas utilizará transacciones.

Ejemplo

Registrar Venta

Cliente

Orden

Detalle

Inventario

Stock

Commit

---

# 18. Principios

Database First

Separation of Concerns

Single Responsibility

REST

Modularidad

Reutilización

---

# 19. Restricciones

No utilizar ORM.

No utilizar Sequelize.

No utilizar acceso directo desde React a SQL Server.

No duplicar lógica de negocio entre Express y SQL Server.

No modificar el modelo relacional sin aprobación.

---

# 20. Decisiones Técnicas

React será únicamente una interfaz.

Express será una capa de comunicación.

SQL Server contendrá la lógica principal.

Los procedimientos almacenados serán el principal mecanismo de modificación de datos.

Las vistas alimentarán reportes.

Los triggers automatizarán procesos.

Las funciones encapsularán cálculos reutilizables.

Las transacciones garantizarán la integridad de los datos.

---

# 21. Escalabilidad

La arquitectura deberá permitir agregar nuevos módulos sin modificar la estructura existente.

Cada módulo deberá ser independiente.

Cada tabla deberá tener su propio controlador, servicio y conjunto de endpoints.

---

# 22. Criterios de Implementación

Antes de implementar una funcionalidad, se deberá verificar:

- ¿Existe la tabla?
- ¿Existe el procedimiento?
- ¿Existe la ruta?
- ¿Existe el servicio?
- ¿Existe la interfaz?

Las implementaciones deberán seguir siempre el flujo:

Base de datos

↓

Backend

↓

Frontend

Nunca en el orden contrario.
