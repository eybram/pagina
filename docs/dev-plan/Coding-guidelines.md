# Broken Pocket
# Coding Guidelines

Versión: 1.0

Estas directrices son de cumplimiento obligatorio durante todo el desarrollo del proyecto.

Su objetivo es garantizar consistencia, mantenibilidad y alineación con los objetivos académicos del curso Base de Datos II.

---

# 1. Principio General

Broken Pocket es un proyecto universitario.

El objetivo principal no es construir un e-commerce comercial, sino demostrar correctamente la aplicación de los conceptos de Base de Datos II.

Toda decisión técnica deberá favorecer la claridad y el valor académico antes que la complejidad tecnológica.

---

# 2. Orden de Prioridad

Cuando exista un conflicto entre documentos, deberá respetarse el siguiente orden:

1. PROJECT_REQUIREMENTS.md
2. ARCHITECTURE.md
3. IMPLEMENTATION_PLAN.md
4. CODING_GUIDELINES.md

Nunca implementar funcionalidades que contradigan estos documentos.

---

# 3. Filosofía de Desarrollo

El proyecto seguirá la metodología:

Database First

↓

Backend

↓

Frontend

↓

Pruebas

↓

Documentación

Nunca desarrollar una interfaz para una funcionalidad inexistente.

---

# 4. Arquitectura

La arquitectura definida en ARCHITECTURE.md es obligatoria.

No modificar:

- estructura de carpetas
- flujo de comunicación
- responsabilidades por capa

sin autorización explícita.

---

# 5. Base de Datos

SQL Server constituye el núcleo del sistema.

Toda lógica relacionada con persistencia de datos deberá implementarse preferentemente mediante:

- Procedimientos almacenados
- Funciones
- Vistas
- Triggers
- Transacciones

Evitar trasladar esta lógica al backend.

---

# 6. Backend

Express actuará únicamente como capa de comunicación.

Sus responsabilidades son:

- recibir solicitudes
- validar datos básicos
- ejecutar procedimientos almacenados
- transformar respuestas
- manejar errores

El backend NO deberá:

- calcular ventas
- actualizar inventario manualmente
- duplicar reglas existentes en SQL Server

---

# 7. Frontend

React será únicamente la interfaz del sistema.

Debe:

- consumir la API
- mostrar información
- validar formularios
- gestionar navegación

No deberá contener lógica de negocio relacionada con la base de datos.

---

# 8. Desarrollo por Módulos

Cada módulo deberá quedar completamente terminado antes de iniciar el siguiente.

Un módulo incluye:

- SQL
- Backend
- Frontend
- Pruebas
- Documentación mínima

No dejar funcionalidades parcialmente implementadas.

---

# 9. Modificaciones al Modelo Relacional

El modelo de datos definido en caparazon.sql es la fuente oficial del proyecto.

No modificar:

- tablas
- claves primarias
- claves foráneas
- restricciones

sin autorización.

Si una modificación es necesaria, deberá justificarse previamente.

---

# 10. Convenciones Generales

## JavaScript

camelCase

## Componentes React

PascalCase

## SQL

snake_case cuando sea posible.

Prefijos obligatorios:

sp_   Procedimientos

fn_   Funciones

vw_   Vistas

tr_   Triggers

---

# 11. Organización del Código

No crear archivos innecesarios.

Cada archivo debe tener una única responsabilidad.

Evitar código duplicado.

Reutilizar componentes cuando sea posible.

---

# 12. Dependencias

Agregar una nueva librería únicamente cuando:

- sea realmente necesaria
- simplifique el desarrollo
- no incremente innecesariamente la complejidad

Evitar dependencias que no aporten valor al proyecto.

---

# 13. Calidad del Código

Todo código deberá ser:

- legible
- modular
- comentado cuando sea necesario
- consistente

Evitar soluciones excesivamente complejas.

---

# 14. Manejo de Errores

Toda funcionalidad deberá manejar errores de forma adecuada.

Frontend

- mensajes claros para el usuario

Backend

- códigos HTTP apropiados
- mensajes consistentes

SQL Server

- TRY...CATCH cuando corresponda
- transacciones protegidas

---

# 15. Seguridad

Validar toda entrada proveniente del usuario.

Utilizar consultas parametrizadas.

Nunca construir SQL mediante concatenación de cadenas.

No exponer información sensible.

---

# 16. Documentación

Toda funcionalidad importante deberá reflejarse en la documentación correspondiente.

Actualizar:

- README
- IMPLEMENTATION_PLAN
- comentarios relevantes

cuando sea necesario.

---

# 17. Definition of Done

Una tarea se considera terminada únicamente cuando:

□ Cumple el PRD.

□ Respeta la arquitectura.

□ Sigue estas directrices.

□ Funciona correctamente.

□ No rompe funcionalidades existentes.

□ Tiene manejo básico de errores.

□ Fue probada.

---

# 18. Restricciones

No utilizar:

- ORM
- Sequelize
- Acceso directo desde React a SQL Server
- SQL generado dinámicamente
- Tecnologías no contempladas en el proyecto

---

# 19. Toma de Decisiones

Antes de implementar una funcionalidad, verificar:

1. ¿Existe en el PRD?

2. ¿Respeta la arquitectura?

3. ¿Existe un procedimiento almacenado que deba utilizarse?

4. ¿La lógica pertenece realmente al backend o a SQL Server?

5. ¿La solución es consistente con el resto del proyecto?

Si alguna respuesta es negativa, detener la implementación y revisar la documentación.

---

# 20. Comportamiento Esperado del Agente

Durante el desarrollo, el agente deberá:

- mantener la estructura definida
- implementar una sola funcionalidad a la vez
- evitar refactorizaciones innecesarias
- documentar decisiones importantes
- priorizar claridad sobre optimización
- pedir confirmación antes de realizar cambios estructurales
- evitar modificar código ya estable sin una razón justificada

---

# 21. Objetivo Final

El resultado esperado es un sistema web funcional, modular y fácil de comprender, que permita demostrar de forma clara y ordenada los conocimientos adquiridos en el curso Base de Datos II.

Cada decisión de desarrollo deberá contribuir a ese objetivo.
