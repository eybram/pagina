/* ============================================================
   BASE DE DATOS: Broken Pocket
   Proyecto Semestral - Base de Datos II
   Facilitadora: Gionella L. Araujo
   ------------------------------------------------------------
   Tienda panameña de mercancía oficial geek (figuras, anime,
   cómics, videojuegos y accesorios de distintas franquicias).
   ============================================================ */
 
USE [Broken Pocket]
GO
 
/* ============================================================
   1. CLIENTE
   ============================================================ */
CREATE TABLE Cliente (
    id_cliente      NVARCHAR(20)    NOT NULL,
    nombre          NVARCHAR(50)    NOT NULL,
    apellido        NVARCHAR(50)    NOT NULL,
    cedula          NVARCHAR(20)    NOT NULL,
    correo          NVARCHAR(100)   NOT NULL,
    telefono        NVARCHAR(20)    NULL,
    provincia       NVARCHAR(50)    NULL,
    fecha_registro  DATE            NOT NULL DEFAULT (GETDATE()),
 
    CONSTRAINT PK_Cliente PRIMARY KEY (id_cliente),
    CONSTRAINT UQ_Cliente_Cedula UNIQUE (cedula),
    CONSTRAINT UQ_Cliente_Correo UNIQUE (correo)
);
GO
 
/* ============================================================
   2. PROVEEDOR
   ============================================================ */
CREATE TABLE Proveedor (
    id_proveedor        NVARCHAR(20)    NOT NULL,
    nombre_proveedor    NVARCHAR(100)   NOT NULL,
    contacto            NVARCHAR(50)    NULL,
    telefono            NVARCHAR(30)    NULL,
    pais                NVARCHAR(50)    NOT NULL DEFAULT ('Panamá'),
    correo              NVARCHAR(100)   NOT NULL,
 
    CONSTRAINT PK_Proveedor PRIMARY KEY (id_proveedor),
    CONSTRAINT UQ_Proveedor_Correo UNIQUE (correo)
);
GO
 
/* ============================================================
   3. CATEGORIA  (normaliza Producto.categoria)
   ============================================================ */
CREATE TABLE Categoria (
    id_categoria        NVARCHAR(20)    NOT NULL,
    nombre_categoria    NVARCHAR(50)    NOT NULL,
    descripcion         NVARCHAR(150)   NULL,
 
    CONSTRAINT PK_Categoria PRIMARY KEY (id_categoria),
    CONSTRAINT UQ_Categoria_Nombre UNIQUE (nombre_categoria)
);
GO
 
/* ============================================================
   4. FRANQUICIA  (normaliza Producto.franquicia)
   ============================================================ */
CREATE TABLE Franquicia (
    id_franquicia       NVARCHAR(20)    NOT NULL,
    nombre_franquicia   NVARCHAR(50)    NOT NULL,
    casa_matriz         NVARCHAR(50)    NULL,  -- ej. Nintendo, Marvel, Square Enix
 
    CONSTRAINT PK_Franquicia PRIMARY KEY (id_franquicia)
);
GO
 
/* ============================================================
   5. PRODUCTO
   ============================================================ */
CREATE TABLE Producto (
    id_producto      NVARCHAR(20)    NOT NULL,
    nombre_producto  NVARCHAR(100)   NOT NULL,
    id_categoria     NVARCHAR(20)    NOT NULL,
    id_franquicia    NVARCHAR(20)    NULL,
    precio           DECIMAL(10,2)   NOT NULL,
    stock            INT             NOT NULL DEFAULT (0),
    id_proveedor     NVARCHAR(20)    NOT NULL,
 
    CONSTRAINT PK_Producto PRIMARY KEY (id_producto),
    CONSTRAINT FK_Producto_Proveedor FOREIGN KEY (id_proveedor)
        REFERENCES Proveedor(id_proveedor),
    CONSTRAINT FK_Producto_Categoria FOREIGN KEY (id_categoria)
        REFERENCES Categoria(id_categoria),
    CONSTRAINT FK_Producto_Franquicia FOREIGN KEY (id_franquicia)
        REFERENCES Franquicia(id_franquicia),
    CONSTRAINT CK_Producto_Precio CHECK (precio > 0),
    CONSTRAINT CK_Producto_Stock CHECK (stock >= 0)
);
GO
 
/* ============================================================
   6. EMPLEADO
   ============================================================ */
CREATE TABLE Empleado (
    id_empleado     NVARCHAR(20)    NOT NULL,
    nombre          NVARCHAR(50)    NOT NULL,
    apellido        NVARCHAR(50)    NOT NULL,
    cargo           NVARCHAR(50)    NOT NULL,
    correo          NVARCHAR(100)   NOT NULL,
    salario         DECIMAL(10,2)   NOT NULL,
 
    CONSTRAINT PK_Empleado PRIMARY KEY (id_empleado),
    CONSTRAINT CK_Empleado_Cargo CHECK (cargo IN ('Vendedor','Cajero','Bodeguero','Administrador')),
    CONSTRAINT CK_Empleado_Salario CHECK (salario > 0)
);
GO
 
/* ============================================================
   7. ORDEN
   (Se conecta con Empleado: el vendedor/cajero que atendió la venta)
   ============================================================ */
CREATE TABLE Orden (
    id_orden        NVARCHAR(20)    NOT NULL,
    id_cliente      NVARCHAR(20)    NOT NULL,
    id_empleado     NVARCHAR(20)    NOT NULL,
    fecha_orden     DATE            NOT NULL DEFAULT (GETDATE()),
    total           DECIMAL(10,2)   NOT NULL,
    metodo_pago     NVARCHAR(20)    NOT NULL,
 
    CONSTRAINT PK_Orden PRIMARY KEY (id_orden),
    CONSTRAINT FK_Orden_Cliente FOREIGN KEY (id_cliente)
        REFERENCES Cliente(id_cliente),
    CONSTRAINT FK_Orden_Empleado FOREIGN KEY (id_empleado)
        REFERENCES Empleado(id_empleado),
    CONSTRAINT CK_Orden_Total CHECK (total >= 0),
    CONSTRAINT CK_Orden_MetodoPago CHECK (metodo_pago IN ('Efectivo','Tarjeta','Transferencia','PayPal','Yappy'))
);
GO
 
/* ============================================================
   8. DETALLE_ORDEN
   (Llave primaria COMPUESTA: un producto no se repite en la misma orden)
   ============================================================ */
CREATE TABLE Detalle_Orden (
    id_orden         NVARCHAR(20)    NOT NULL,
    id_producto      NVARCHAR(20)    NOT NULL,
    cantidad         INT             NOT NULL,
    precio_unitario  DECIMAL(10,2)   NOT NULL,
    subtotal         DECIMAL(10,2)   NOT NULL,
 
    CONSTRAINT PK_DetalleOrden PRIMARY KEY (id_orden, id_producto),
    CONSTRAINT FK_DetalleOrden_Orden FOREIGN KEY (id_orden)
        REFERENCES Orden(id_orden),
    CONSTRAINT FK_DetalleOrden_Producto FOREIGN KEY (id_producto)
        REFERENCES Producto(id_producto),
    CONSTRAINT CK_DetalleOrden_Cantidad CHECK (cantidad > 0),
    CONSTRAINT CK_DetalleOrden_PrecioUnitario CHECK (precio_unitario > 0)
);
GO
 
/* ============================================================
   9. INVENTARIO_MOVIMIENTOS
   ============================================================ */
CREATE TABLE Inventario_Movimientos (
    id_mov              NVARCHAR(20)    NOT NULL,
    id_producto         NVARCHAR(20)    NOT NULL,
    tipo_movimiento     NVARCHAR(20)    NOT NULL,
    cantidad            INT             NOT NULL,
    fecha_movimiento    DATE            NOT NULL DEFAULT (GETDATE()),
    descripcion         NVARCHAR(200)   NULL,
 
    CONSTRAINT PK_InventarioMovimientos PRIMARY KEY (id_mov),
    CONSTRAINT FK_Inventario_Producto FOREIGN KEY (id_producto)
        REFERENCES Producto(id_producto),
    CONSTRAINT CK_Inventario_Tipo CHECK (tipo_movimiento IN ('Entrada','Salida')),
    CONSTRAINT CK_Inventario_Cantidad CHECK (cantidad > 0)
);
GO
 
/* ============================================================
   VERIFICACIÓN RÁPIDA
   ============================================================ */
SELECT * FROM dbo.Cliente;
SELECT * FROM dbo.Proveedor;
SELECT * FROM dbo.Categoria;
SELECT * FROM dbo.Franquicia;
SELECT * FROM dbo.Producto;
SELECT * FROM dbo.Empleado;
SELECT * FROM dbo.Orden;
SELECT * FROM dbo.Detalle_Orden;
SELECT * FROM dbo.Inventario_Movimientos;
