# Broken Pocket
# Decisions Log

Versión: 1.0

---

# Propósito

Este documento registra las decisiones importantes tomadas durante el desarrollo del proyecto.

Su objetivo es mantener la coherencia del sistema y evitar que decisiones ya aprobadas sean modificadas en futuras sesiones de desarrollo.

No pretende documentar cambios menores ni tareas de implementación.

---

# Instrucciones para el Agente

Antes de proponer una modificación importante, revisar este documento.

Una decisión registrada aquí se considera aprobada y no debe modificarse sin autorización explícita.

Registrar únicamente decisiones que afecten:

- Arquitectura
- Modelo de datos
- Tecnologías principales
- Organización del proyecto
- Flujo de negocio
- Estrategia de desarrollo

No registrar:

- Correcciones menores
- Refactorizaciones pequeñas
- Cambios visuales
- Correcciones de errores
- Avances de implementación

---

# Formato

Cada decisión utilizará la siguiente estructura.

---

## DEC-XXX

Estado

Propuesta | Aprobada | Reemplazada

Fecha

AAAA-MM-DD

Contexto

Problema que motivó la decisión.

Decisión

Decisión tomada.

Justificación

Razón por la cual fue aprobada.

Consecuencias

Impacto esperado.

---

# Registro de Decisiones

---

## DEC-001

Estado

Aprobada

Fecha

2026-07-16

Contexto

Se requiere desarrollar una propuesta de automatización para el curso Base de Datos II.

Decisión

El proyecto consistirá en un sistema integral de gestión comercial para la empresa ficticia Broken Pocket.

Justificación

Permite aplicar todos los conceptos del curso utilizando un escenario empresarial coherente.

Consecuencias

Todas las funcionalidades futuras deberán relacionarse con los procesos comerciales de Broken Pocket.

---

## DEC-002

Estado

Aprobada

Fecha

2026-07-16

Contexto

Era necesario definir el gestor de base de datos oficial.

Decisión

Se utilizará Microsoft SQL Server 2025 Developer Edition.

Justificación

Es la plataforma utilizada durante el desarrollo y proporciona todas las funcionalidades necesarias para el proyecto.

Consecuencias

Todo el código SQL deberá ser compatible con SQL Server 2025.

---

## DEC-003

Estado

Aprobada

Fecha

2026-07-16

Contexto

Era necesario definir la arquitectura general del proyecto.

Decisión

Adoptar una arquitectura Database First.

Justificación

La asignatura evalúa principalmente el uso de SQL Server.

Consecuencias

Toda implementación comenzará por la base de datos antes de desarrollar el backend y el frontend.

---

## DEC-004

Estado

Aprobada

Fecha

2026-07-16

Contexto

Era necesario definir dónde residirá la lógica de negocio.

Decisión

La lógica relacionada con la persistencia de datos residirá principalmente en SQL Server mediante procedimientos almacenados, funciones, vistas, triggers y transacciones.

Justificación

Reduce duplicación de reglas y aprovecha las capacidades del gestor de base de datos.

Consecuencias

El backend actuará principalmente como intermediario entre la aplicación y SQL Server.

---

## DEC-005

Estado

Aprobada

Fecha

2026-07-16

Contexto

Era necesario seleccionar el stack tecnológico.

Decisión

Utilizar React, Vite, Node.js, Express, mssql y SQL Server.

Justificación

Es un stack sencillo, ampliamente documentado y adecuado para el alcance del proyecto.

Consecuencias

No se incorporarán tecnologías alternativas sin aprobación.

---

## DEC-006

Estado

Aprobada

Fecha

2026-07-16

Contexto

Era necesario definir el método de acceso a la base de datos.

Decisión

El backend utilizará el paquete mssql.

No se utilizarán ORMs.

Justificación

Permite ejecutar procedimientos almacenados directamente y mantiene el control sobre el código SQL.

Consecuencias

Todas las operaciones de persistencia utilizarán consultas parametrizadas o procedimientos almacenados.

---

## DEC-007

Estado

Aprobada

Fecha

2026-07-16

Contexto

Era necesario establecer la organización del desarrollo.

Decisión

El proyecto se implementará por módulos funcionales.

Cada módulo deberá completarse de extremo a extremo antes de iniciar el siguiente.

Justificación

Reduce dependencias entre módulos y facilita el trabajo incremental.

Consecuencias

El orden oficial de implementación será el definido en IMPLEMENTATION_PLAN.md.

---

## DEC-008

Estado

Aprobada

Fecha

2026-07-16

Contexto

Era necesario definir la organización del backend.

Decisión

El backend utilizará una estructura modular organizada por funcionalidades.

Justificación

Mejora la mantenibilidad y facilita el desarrollo independiente de cada módulo.

Consecuencias

Cada módulo tendrá sus propias rutas, controladores, servicios y validaciones.

---

## DEC-009

Estado

Aprobada

Fecha

2026-07-16

Contexto

Era necesario definir el propósito del frontend.

Decisión

React actuará exclusivamente como interfaz de usuario.

Justificación

La lógica principal del negocio debe permanecer fuera de la interfaz.

Consecuencias

El frontend únicamente consumirá la API REST.

---

## DEC-010

Estado

Aprobada

Fecha

2026-07-16

Contexto

Era necesario establecer la estrategia de desarrollo.

Decisión

Antes de implementar cualquier funcionalidad se deberán consultar, en este orden:

1. PROJECT_REQUIREMENTS.md
2. ARCHITECTURE.md
3. IMPLEMENTATION_PLAN.md
4. CODING_GUIDELINES.md
5. DECISIONS_LOG.md

Justificación

Garantiza consistencia entre todas las sesiones de desarrollo.

Consecuencias

Las decisiones registradas tendrán prioridad sobre nuevas propuestas que las contradigan.

---

# Historial de Cambios

Este documento deberá actualizarse únicamente cuando exista una decisión que modifique la dirección del proyecto.

No registrar avances de implementación.

No registrar tareas completadas.

No registrar correcciones menores.

Registrar únicamente decisiones con impacto arquitectónico o funcional.
