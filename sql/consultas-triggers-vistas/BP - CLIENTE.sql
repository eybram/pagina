--CLIENTE

USE [Broken Pocket]
GO

/* ============================================================
   BLOQUE 1: PROCEDIMIENTOS ALMACENADOS CRUD - CLIENTE
   ============================================================ */

-- 1.1 Insertar
IF OBJECT_ID('SP_Cliente_Insertar', 'P') IS NOT NULL
    DROP PROCEDURE SP_Cliente_Insertar;
GO
CREATE PROCEDURE SP_Cliente_Insertar
    @id_cliente     NVARCHAR(20),
    @nombre         NVARCHAR(50),
    @apellido       NVARCHAR(50),
    @cedula         NVARCHAR(20),
    @correo         NVARCHAR(100),
    @telefono       NVARCHAR(20),
    @provincia      NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Cliente WHERE id_cliente = @id_cliente)
        BEGIN
            RAISERROR('Ya existe un cliente con el id %s.', 16, 1, @id_cliente);
            RETURN;
        END

        INSERT INTO Cliente (id_cliente, nombre, apellido, cedula, correo, telefono, provincia)
        VALUES (@id_cliente, @nombre, @apellido, @cedula, @correo, @telefono, @provincia);

        PRINT 'Cliente insertado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al insertar cliente: ' + ERROR_MESSAGE();
    END CATCH
END
GO

-- 1.2 Actualizar
IF OBJECT_ID('SP_Cliente_Actualizar', 'P') IS NOT NULL
    DROP PROCEDURE SP_Cliente_Actualizar;
GO
CREATE PROCEDURE SP_Cliente_Actualizar
    @id_cliente     NVARCHAR(20),
    @nombre         NVARCHAR(50),
    @apellido       NVARCHAR(50),
    @cedula         NVARCHAR(20),
    @correo         NVARCHAR(100),
    @telefono       NVARCHAR(20),
    @provincia      NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Cliente WHERE id_cliente = @id_cliente)
        BEGIN
            RAISERROR('No existe un cliente con el id %s.', 16, 1, @id_cliente);
            RETURN;
        END

        UPDATE Cliente
        SET nombre = @nombre,
            apellido = @apellido,
            cedula = @cedula,
            correo = @correo,
            telefono = @telefono,
            provincia = @provincia
        WHERE id_cliente = @id_cliente;

        PRINT 'Cliente actualizado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al actualizar cliente: ' + ERROR_MESSAGE();
    END CATCH
END
GO

-- 1.3 Eliminar por PK
IF OBJECT_ID('SP_Cliente_Eliminar', 'P') IS NOT NULL
    DROP PROCEDURE SP_Cliente_Eliminar;
GO
CREATE PROCEDURE SP_Cliente_Eliminar
    @id_cliente NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Cliente WHERE id_cliente = @id_cliente)
        BEGIN
            RAISERROR('No existe un cliente con el id %s.', 16, 1, @id_cliente);
            RETURN;
        END

        DELETE FROM Cliente WHERE id_cliente = @id_cliente;
        PRINT 'Cliente eliminado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al eliminar cliente (verifique que no tenga órdenes asociadas): ' + ERROR_MESSAGE();
    END CATCH
END
GO

-- 1.4 Buscar por PK
IF OBJECT_ID('SP_Cliente_BuscarPorId', 'P') IS NOT NULL
    DROP PROCEDURE SP_Cliente_BuscarPorId;
GO
CREATE PROCEDURE SP_Cliente_BuscarPorId
    @id_cliente NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Cliente WHERE id_cliente = @id_cliente)
    BEGIN
        PRINT 'No se encontró ningún cliente con ese id.';
        RETURN;
    END

    SELECT * FROM Cliente WHERE id_cliente = @id_cliente;
END
GO

-- 1.5 Listar todos
IF OBJECT_ID('SP_Cliente_ListarTodos', 'P') IS NOT NULL
    DROP PROCEDURE SP_Cliente_ListarTodos;
GO
CREATE PROCEDURE SP_Cliente_ListarTodos
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM Cliente ORDER BY apellido, nombre;
END
GO


/* ============================================================
   BLOQUE 2: PROCEDIMIENTOS ALMACENADOS CRUD - PROVEEDOR
   ============================================================ */

-- 2.1 Insertar
IF OBJECT_ID('SP_Proveedor_Insertar', 'P') IS NOT NULL
    DROP PROCEDURE SP_Proveedor_Insertar;
GO
CREATE PROCEDURE SP_Proveedor_Insertar
    @id_proveedor       NVARCHAR(20),
    @nombre_proveedor   NVARCHAR(100),
    @contacto           NVARCHAR(50),
    @telefono           NVARCHAR(30),
    @pais               NVARCHAR(50) = NULL,
    @correo             NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Proveedor WHERE id_proveedor = @id_proveedor)
        BEGIN
            RAISERROR('Ya existe un proveedor con el id %s.', 16, 1, @id_proveedor);
            RETURN;
        END

        IF @pais IS NULL
            INSERT INTO Proveedor (id_proveedor, nombre_proveedor, contacto, telefono, correo)
            VALUES (@id_proveedor, @nombre_proveedor, @contacto, @telefono, @correo);
        ELSE
            INSERT INTO Proveedor (id_proveedor, nombre_proveedor, contacto, telefono, pais, correo)
            VALUES (@id_proveedor, @nombre_proveedor, @contacto, @telefono, @pais, @correo);

        PRINT 'Proveedor insertado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al insertar proveedor: ' + ERROR_MESSAGE();
    END CATCH
END
GO

-- 2.2 Actualizar
IF OBJECT_ID('SP_Proveedor_Actualizar', 'P') IS NOT NULL
    DROP PROCEDURE SP_Proveedor_Actualizar;
GO
CREATE PROCEDURE SP_Proveedor_Actualizar
    @id_proveedor       NVARCHAR(20),
    @nombre_proveedor   NVARCHAR(100),
    @contacto           NVARCHAR(50),
    @telefono           NVARCHAR(30),
    @pais               NVARCHAR(50),
    @correo             NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Proveedor WHERE id_proveedor = @id_proveedor)
        BEGIN
            RAISERROR('No existe un proveedor con el id %s.', 16, 1, @id_proveedor);
            RETURN;
        END

        UPDATE Proveedor
        SET nombre_proveedor = @nombre_proveedor,
            contacto = @contacto,
            telefono = @telefono,
            pais = @pais,
            correo = @correo
        WHERE id_proveedor = @id_proveedor;

        PRINT 'Proveedor actualizado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al actualizar proveedor: ' + ERROR_MESSAGE();
    END CATCH
END
GO

-- 2.3 Eliminar por PK
IF OBJECT_ID('SP_Proveedor_Eliminar', 'P') IS NOT NULL
    DROP PROCEDURE SP_Proveedor_Eliminar;
GO
CREATE PROCEDURE SP_Proveedor_Eliminar
    @id_proveedor NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Proveedor WHERE id_proveedor = @id_proveedor)
        BEGIN
            RAISERROR('No existe un proveedor con el id %s.', 16, 1, @id_proveedor);
            RETURN;
        END

        DELETE FROM Proveedor WHERE id_proveedor = @id_proveedor;
        PRINT 'Proveedor eliminado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al eliminar proveedor (verifique que no tenga productos asociados): ' + ERROR_MESSAGE();
    END CATCH
END
GO

-- 2.4 Buscar por PK
IF OBJECT_ID('SP_Proveedor_BuscarPorId', 'P') IS NOT NULL
    DROP PROCEDURE SP_Proveedor_BuscarPorId;
GO
CREATE PROCEDURE SP_Proveedor_BuscarPorId
    @id_proveedor NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Proveedor WHERE id_proveedor = @id_proveedor)
    BEGIN
        PRINT 'No se encontró ningún proveedor con ese id.';
        RETURN;
    END

    SELECT * FROM Proveedor WHERE id_proveedor = @id_proveedor;
END
GO

-- 2.5 Listar todos
IF OBJECT_ID('SP_Proveedor_ListarTodos', 'P') IS NOT NULL
    DROP PROCEDURE SP_Proveedor_ListarTodos;
GO
CREATE PROCEDURE SP_Proveedor_ListarTodos
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM Proveedor ORDER BY nombre_proveedor;
END
GO


/* ============================================================
   BLOQUE 3: PROCEDIMIENTOS DE LÓGICA DE NEGOCIO (2 por tabla)
   ============================================================ */

-- 3.1 Historial de compras de un cliente
IF OBJECT_ID('SP_Cliente_HistorialCompras', 'P') IS NOT NULL
    DROP PROCEDURE SP_Cliente_HistorialCompras;
GO
CREATE PROCEDURE SP_Cliente_HistorialCompras
    @id_cliente NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Cliente WHERE id_cliente = @id_cliente)
    BEGIN
        PRINT 'No existe un cliente con ese id.';
        RETURN;
    END

    SELECT
        o.id_orden,
        o.fecha_orden,
        p.nombre_producto,
        d.cantidad,
        d.precio_unitario,
        d.subtotal,
        o.metodo_pago
    FROM Orden o
    JOIN Detalle_Orden d ON d.id_orden = o.id_orden
    JOIN Producto p ON p.id_producto = d.id_producto
    WHERE o.id_cliente = @id_cliente
    ORDER BY o.fecha_orden DESC;
END
GO

-- 3.2 Clientes frecuentes (usa GROUP BY HAVING - útil para promociones)
IF OBJECT_ID('SP_Cliente_ClientesFrecuentes', 'P') IS NOT NULL
    DROP PROCEDURE SP_Cliente_ClientesFrecuentes;
GO
CREATE PROCEDURE SP_Cliente_ClientesFrecuentes
    @min_compras INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        c.id_cliente,
        CONCAT(c.nombre, ' ', c.apellido) AS nombre_completo,
        COUNT(o.id_orden) AS cantidad_ordenes,
        SUM(o.total) AS total_gastado
    FROM Cliente c
    JOIN Orden o ON o.id_cliente = c.id_cliente
    GROUP BY c.id_cliente, c.nombre, c.apellido
    HAVING COUNT(o.id_orden) >= @min_compras
    ORDER BY total_gastado DESC;
END
GO

-- 3.3 Productos que suministra un proveedor específico
IF OBJECT_ID('SP_Proveedor_ProductosSuministrados', 'P') IS NOT NULL
    DROP PROCEDURE SP_Proveedor_ProductosSuministrados;
GO
CREATE PROCEDURE SP_Proveedor_ProductosSuministrados
    @id_proveedor NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Proveedor WHERE id_proveedor = @id_proveedor)
    BEGIN
        PRINT 'No existe un proveedor con ese id.';
        RETURN;
    END

    SELECT
        p.id_producto,
        p.nombre_producto,
        c.nombre_categoria,
        f.nombre_franquicia,
        p.precio,
        p.stock
    FROM Producto p
    JOIN Categoria c ON c.id_categoria = p.id_categoria
    LEFT JOIN Franquicia f ON f.id_franquicia = p.id_franquicia
    WHERE p.id_proveedor = @id_proveedor
    ORDER BY p.nombre_producto;
END
GO

-- 3.4 Resumen de inventario por proveedor (usa WHILE, sin parámetros)
IF OBJECT_ID('SP_Proveedor_ResumenInventario', 'P') IS NOT NULL
    DROP PROCEDURE SP_Proveedor_ResumenInventario;
GO
CREATE PROCEDURE SP_Proveedor_ResumenInventario
AS
BEGIN
    SET NOCOUNT ON;

    IF OBJECT_ID('tempdb..#ResumenProveedor') IS NOT NULL
        DROP TABLE #ResumenProveedor;

    CREATE TABLE #ResumenProveedor (
        id_proveedor        NVARCHAR(20),
        nombre_proveedor    NVARCHAR(100),
        cantidad_productos  INT,
        valor_inventario    DECIMAL(12,2)
    );

    DECLARE @listaProveedores TABLE (fila INT IDENTITY(1,1), id_proveedor NVARCHAR(20));
    INSERT INTO @listaProveedores (id_proveedor) SELECT id_proveedor FROM Proveedor;

    DECLARE @contador INT = 1;
    DECLARE @total INT = (SELECT COUNT(*) FROM @listaProveedores);
    DECLARE @idActual NVARCHAR(20);

    WHILE @contador <= @total
    BEGIN
        SELECT @idActual = id_proveedor FROM @listaProveedores WHERE fila = @contador;

        INSERT INTO #ResumenProveedor (id_proveedor, nombre_proveedor, cantidad_productos, valor_inventario)
        SELECT
            pr.id_proveedor,
            pr.nombre_proveedor,
            COUNT(p.id_producto),
            ISNULL(SUM(p.precio * p.stock), 0)
        FROM Proveedor pr
        LEFT JOIN Producto p ON p.id_proveedor = pr.id_proveedor
        WHERE pr.id_proveedor = @idActual
        GROUP BY pr.id_proveedor, pr.nombre_proveedor;

        SET @contador = @contador + 1;
    END

    SELECT * FROM #ResumenProveedor ORDER BY valor_inventario DESC;

    DROP TABLE #ResumenProveedor;
END
GO


/* ============================================================
   BLOQUE 4: VISTAS (2 por tabla)
   ============================================================ */

IF OBJECT_ID('VW_Clientes_Resumen', 'V') IS NOT NULL
    DROP VIEW VW_Clientes_Resumen;
GO
CREATE VIEW VW_Clientes_Resumen AS
SELECT
    c.id_cliente,
    CONCAT(c.nombre, ' ', c.apellido) AS nombre_completo,
    c.correo,
    c.provincia,
    COUNT(o.id_orden) AS cantidad_ordenes,
    ISNULL(SUM(o.total), 0) AS total_gastado
FROM Cliente c
LEFT JOIN Orden o ON o.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nombre, c.apellido, c.correo, c.provincia;
GO

IF OBJECT_ID('VW_Clientes_PorProvincia', 'V') IS NOT NULL
    DROP VIEW VW_Clientes_PorProvincia;
GO
CREATE VIEW VW_Clientes_PorProvincia AS
SELECT
    provincia,
    COUNT(*) AS cantidad_clientes
FROM Cliente
GROUP BY provincia;
GO

IF OBJECT_ID('VW_Proveedores_Catalogo', 'V') IS NOT NULL
    DROP VIEW VW_Proveedores_Catalogo;
GO
CREATE VIEW VW_Proveedores_Catalogo AS
SELECT
    pr.id_proveedor,
    pr.nombre_proveedor,
    pr.pais,
    COUNT(p.id_producto) AS cantidad_productos,
    ISNULL(SUM(p.stock), 0) AS stock_total
FROM Proveedor pr
LEFT JOIN Producto p ON p.id_proveedor = pr.id_proveedor
GROUP BY pr.id_proveedor, pr.nombre_proveedor, pr.pais;
GO

IF OBJECT_ID('VW_Proveedores_PaisExtranjero', 'V') IS NOT NULL
    DROP VIEW VW_Proveedores_PaisExtranjero;
GO
CREATE VIEW VW_Proveedores_PaisExtranjero AS
SELECT id_proveedor, nombre_proveedor, pais, telefono, correo
FROM Proveedor
WHERE pais <> N'Panamá';
GO


/* ============================================================
   BLOQUE 5: TRIGGER
   ============================================================ */

IF OBJECT_ID('TR_Cliente_ValidarCorreo', 'TR') IS NOT NULL
    DROP TRIGGER TR_Cliente_ValidarCorreo;
GO
CREATE TRIGGER TR_Cliente_ValidarCorreo
ON Cliente
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (
            SELECT 1 FROM inserted
            WHERE correo NOT LIKE '_%@_%.__%'
        )
        BEGIN
            RAISERROR('El correo ingresado no tiene un formato válido (debe contener @ y un dominio).', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        PRINT 'Error en la validación de correo: ' + ERROR_MESSAGE();
    END CATCH
END
GO


/* ============================================================
   BLOQUE 6: CONSULTAS (4 de las 25 del proyecto)
   ============================================================ */

-- 6.1 UPPER + CONCAT: nombre completo de clientes en mayúsculas
SELECT
    id_cliente,
    UPPER(CONCAT(nombre, ' ', apellido)) AS nombre_completo,
    correo
FROM Cliente;
GO

-- 6.2 LEFT: clientes cuyo teléfono es un número celular (empieza en 6)
SELECT nombre, apellido, telefono
FROM Cliente
WHERE LEFT(telefono, 1) = '6';
GO

-- 6.3 IF EXISTS: verificar si un cliente específico ya tiene compras registradas
IF EXISTS (SELECT 1 FROM Orden WHERE id_cliente = 'Pd1')
    PRINT 'El cliente Pd1 ya tiene compras registradas.';
ELSE
    PRINT 'El cliente Pd1 aún no ha realizado compras.';
GO

-- 6.4 SUM + GROUP BY: valor de inventario que suministra cada proveedor
SELECT
    pr.nombre_proveedor,
    SUM(p.precio * p.stock) AS valor_inventario_suministrado
FROM Proveedor pr
JOIN Producto p ON p.id_proveedor = pr.id_proveedor
GROUP BY pr.nombre_proveedor
ORDER BY valor_inventario_suministrado DESC;
GO
