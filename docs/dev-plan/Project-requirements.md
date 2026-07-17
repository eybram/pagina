# Broken Pocket
# Product Requirements Document (PRD)

Versión: 2.0

Proyecto: Semestral Base de Datos II

Universidad Tecnológica de Panamá

---

# 1. Propósito del Documento

Este documento define los requisitos funcionales y de negocio del sistema Broken Pocket.

Su objetivo es describir qué debe hacer el sistema y cuáles son las necesidades que debe cubrir.

Los detalles técnicos de implementación se encuentran en el documento **ARCHITECTURE.md**.

---

# 2. Descripción General

Broken Pocket es una empresa ficticia dedicada a la venta de videojuegos, consolas, accesorios y artículos coleccionables.

Actualmente la empresa administra sus procesos comerciales de forma manual, utilizando hojas de cálculo y registros independientes para controlar clientes, productos e inventario.

Este método provoca:

- pérdida de información
- errores en el inventario
- dificultad para controlar las ventas
- ausencia de indicadores gerenciales
- procesos lentos
- duplicidad de datos

Como solución, se desarrollará un sistema web conectado a una base de datos SQL Server que automatice las principales operaciones comerciales de la empresa.

El proyecto corresponde al curso Base de Datos II de la Universidad Tecnológica de Panamá.

---

# 3. Objetivo General

Diseñar e implementar un sistema de información que permita automatizar los procesos de ventas, inventario y administración de Broken Pocket mediante una aplicación web integrada con Microsoft SQL Server.

---

# 4. Objetivos Específicos

El sistema deberá permitir:

- administrar productos
- administrar categorías
- administrar franquicias
- administrar proveedores
- administrar empleados
- registrar clientes
- registrar ventas
- controlar inventario
- generar reportes gerenciales
- mantener la integridad de la información

---

# 5. Objetivos No Funcionales

El sistema deberá cumplir con los siguientes criterios:

- mantener la integridad de la información
- ofrecer una interfaz sencilla
- facilitar el mantenimiento del proyecto
- permitir futuras ampliaciones
- ser demostrable durante la sustentación
- mantener una separación clara entre interfaz, API y base de datos

---

# 6. Alcance

El sistema estará compuesto por cuatro módulos principales.

## Catálogo

Permite consultar los productos disponibles.

Funciones principales

- visualizar productos
- buscar productos
- filtrar productos
- consultar detalles

---

## Ventas

Permite registrar las compras realizadas por los clientes.

Funciones principales

- registrar clientes
- registrar órdenes
- registrar detalles de venta
- consultar ventas

---

## Administración

Permite administrar la información de la empresa.

Incluye

- productos
- categorías
- franquicias
- proveedores
- empleados
- inventario

---

## Dashboard

Permite consultar indicadores para apoyar la toma de decisiones.

Ejemplos

- ventas por período
- productos más vendidos
- productos agotados
- stock crítico
- clientes frecuentes
- ventas por categoría
- ventas por franquicia

---

# 7. Actores

## Cliente

Puede

- consultar productos
- agregar productos al carrito
- realizar compras

---

## Empleado

Puede

- registrar clientes
- registrar ventas
- consultar órdenes

---

## Administrador

Puede administrar

- productos
- categorías
- franquicias
- proveedores
- empleados
- inventario

---

## Gerente

Puede consultar

- dashboard
- estadísticas
- reportes

---

# 8. Casos de Uso

## Cliente

- Buscar producto
- Consultar producto
- Agregar al carrito
- Realizar compra

## Empleado

- Registrar cliente
- Registrar venta
- Consultar venta

## Administrador

- Administrar productos
- Administrar categorías
- Administrar franquicias
- Administrar proveedores
- Administrar empleados
- Administrar inventario

## Gerente

- Consultar dashboard
- Consultar ventas
- Consultar inventario
- Consultar clientes

---

# 9. Base de Datos

El sistema utilizará una base de datos relacional desarrollada en Microsoft SQL Server.

El modelo de datos oficial está definido en el archivo:

caparazon.sql

Las tablas principales son:

- Categoria
- Franquicia
- Producto
- Cliente
- Empleado
- Proveedor
- Orden
- Detalle_Orden
- Inventario_Movimientos

Toda modificación del modelo deberá mantenerse consistente con el esquema oficial del proyecto.

---

# 10. Reglas de Negocio

## Productos

- El precio debe ser mayor que cero.
- El stock nunca puede ser negativo.

## Clientes

- No pueden existir clientes duplicados.
- La cédula debe ser única.
- El correo debe ser único.

## Ventas

- No se podrá vender un producto sin stock.
- Toda venta deberá registrar su detalle.
- Toda venta actualizará el inventario.

## Inventario

- Toda entrada incrementará el stock.
- Toda salida disminuirá el stock.

## Integridad

El sistema deberá respetar todas las restricciones definidas en la base de datos.

---

# 11. Funcionalidades

El sistema deberá permitir:

## Catálogo

- consultar productos
- buscar productos
- filtrar productos

## Producto

- visualizar información
- consultar disponibilidad

## Carrito

- agregar productos
- eliminar productos
- modificar cantidades

## Checkout

- registrar cliente
- confirmar compra
- generar orden

## Administración

CRUD para

- Productos
- Categorías
- Franquicias
- Proveedores
- Empleados

---

# 12. Dashboard

El sistema deberá ofrecer información para apoyar la toma de decisiones.

Indicadores esperados

- ventas totales
- ventas por categoría
- ventas por franquicia
- productos más vendidos
- clientes frecuentes
- productos sin movimiento
- productos agotados
- stock crítico

---

# 13. Requisitos de Base de Datos

La solución deberá implementar las funcionalidades solicitadas por la asignatura, incluyendo:

- procedimientos almacenados
- funciones
- vistas
- triggers
- transacciones
- consultas estratégicas
- reglas de integridad

Todos estos elementos deberán apoyar directamente las funcionalidades del sistema.

---

# 14. Restricciones

El proyecto corresponde a una asignatura universitaria.

La prioridad del proyecto es demostrar conocimientos de Base de Datos II.

No se desarrollarán funcionalidades que no aporten al objetivo académico del proyecto.

---

# 15. No Objetivos

Este proyecto no contempla:

- pasarelas de pago reales
- autenticación mediante terceros
- envío de correos electrónicos
- aplicaciones móviles
- microservicios
- Docker
- Kubernetes
- despliegue en producción
- optimizaciones empresariales

---

# 16. Estado Actual

Completado

- Modelo relacional
- Scripts SQL
- Datos de prueba
- Documento de requisitos
- Arquitectura del sistema

Pendiente

- Frontend
- Backend
- API REST
- Dashboard
- Integración
- Pruebas

---

# 17. Criterios de Éxito

El proyecto será considerado terminado cuando:

- permita administrar la información de Broken Pocket
- automatice el proceso de ventas
- automatice el inventario
- genere reportes gerenciales
- utilice correctamente SQL Server
- respete todas las reglas de integridad
- pueda ser presentado y sustentado como una propuesta de automatización empresarial

---

# 18. Documentación Relacionada

Este documento forma parte de la documentación oficial del proyecto.

Se complementa con:

- Architecture.md
- Implementation_Plan.md
- Coding-guidelines.md
- Decisions-Log.md
