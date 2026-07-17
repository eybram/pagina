# Frontend

Aplicación web desarrollada con React y Vite para exponer la interfaz de Broken Pocket.

## Objetivo

El frontend debe ofrecer una experiencia clara para consultar productos, agregar elementos al carrito y completar el proceso de compra sin implementar reglas de negocio en el cliente.

## Tecnologías

- React
- Vite
- React Router

## Estructura actual

```text
src/
  App.jsx
  main.jsx
  components/
  context/
  pages/
  services/
  mocks/
```

## Responsabilidades

El frontend debe:

- mostrar información desde la API
- gestionar la navegación
- validar formularios básicos
- mantener el estado del carrito
- presentar mensajes de carga o error

No debe:

- ejecutar SQL
- calcular inventario o ventas
- duplicar lógica de negocio ya implementada en la base de datos

## Páginas principales

- Inicio
- Catálogo
- Producto
- Carrito
- Checkout
- Dashboard
- Administración

## Ejecución

```bash
npm install
npm run dev
```

## Convenciones

- componentes en PascalCase
- variables y funciones en camelCase
- un componente por archivo cuando sea posible
- centralizar llamadas a la API en la carpeta services
