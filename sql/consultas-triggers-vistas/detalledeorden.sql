USE [Broken Pocket]
GO

-- =========================================================
-- TABLA DE AUDITORÍA - DETALLE_ORDEN
-- =========================================================
IF OBJECT_ID('Auditoria_DetalleOrden') IS NOT NULL DROP TABLE Auditoria_DetalleOrden;
GO
CREATE TABLE Auditoria_DetalleOrden (
    id_auditoria    INT IDENTITY(1,1) PRIMARY KEY,
    id_orden        NVARCHAR(20),
    id_producto     NVARCHAR(20),
    accion          NVARCHAR(10),
    usuario_bd      NVARCHAR(100),
    fecha_accion    DATETIME DEFAULT GETDATE()
);
GO

-- =========================================================
-- PROCEDIMIENTOS ALMACENADOS - DETALLE_ORDEN (7)
-- =========================================================

-- 1. Insertar
IF OBJECT_ID('sp_DetalleOrden_Insertar') IS NOT NULL DROP PROCEDURE sp_DetalleOrden_Insertar;
GO
CREATE PROCEDURE sp_DetalleOrden_Insertar
    @id_orden NVARCHAR(20), @id_producto NVARCHAR(20), @cantidad INT, @precio_unitario DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Orden WHERE id_orden = @id_orden)
    BEGIN
        RAISERROR('La orden no existe.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM Producto WHERE id_producto = @id_producto)
    BEGIN
        RAISERROR('El producto no existe.', 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM Detalle_Orden WHERE id_orden = @id_orden AND id_producto = @id_producto)
    BEGIN
        RAISERROR('Ese producto ya está en la orden, use actualizar.', 16, 1);
        RETURN;
    END
    INSERT INTO Detalle_Orden (id_orden, id_producto, cantidad, precio_unitario, subtotal)
    VALUES (@id_orden, @id_producto, @cantidad, @precio_unitario, @cantidad * @precio_unitario);
END
GO

-- 2. Actualizar
IF OBJECT_ID('sp_DetalleOrden_Actualizar') IS NOT NULL DROP PROCEDURE sp_DetalleOrden_Actualizar;
GO
CREATE PROCEDURE sp_DetalleOrden_Actualizar
    @id_orden NVARCHAR(20), @id_producto NVARCHAR(20), @cantidad INT, @precio_unitario DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Detalle_Orden WHERE id_orden = @id_orden AND id_producto = @id_producto)
    BEGIN
        RAISERROR('El detalle no existe.', 16, 1);
        RETURN;
    END
    UPDATE Detalle_Orden
    SET cantidad = @cantidad, precio_unitario = @precio_unitario, subtotal = @cantidad * @precio_unitario
    WHERE id_orden = @id_orden AND id_producto = @id_producto;
END
GO

-- 3. Eliminar por PK compuesta
IF OBJECT_ID('sp_DetalleOrden_Eliminar') IS NOT NULL DROP PROCEDURE sp_DetalleOrden_Eliminar;
GO
CREATE PROCEDURE sp_DetalleOrden_Eliminar @id_orden NVARCHAR(20), @id_producto NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Detalle_Orden WHERE id_orden = @id_orden AND id_producto = @id_producto)
    BEGIN
        RAISERROR('El detalle no existe.', 16, 1);
        RETURN;
    END
    DELETE FROM Detalle_Orden WHERE id_orden = @id_orden AND id_producto = @id_producto;
END
GO

-- 4. Buscar por PK compuesta
IF OBJECT_ID('sp_DetalleOrden_BuscarPorID') IS NOT NULL DROP PROCEDURE sp_DetalleOrden_BuscarPorID;
GO
CREATE PROCEDURE sp_DetalleOrden_BuscarPorID @id_orden NVARCHAR(20), @id_producto NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM Detalle_Orden WHERE id_orden = @id_orden AND id_producto = @id_producto;
END
GO

-- 5. Obtener todos
IF OBJECT_ID('sp_DetalleOrden_ObtenerTodos') IS NOT NULL DROP PROCEDURE sp_DetalleOrden_ObtenerTodos;
GO
CREATE PROCEDURE sp_DetalleOrden_ObtenerTodos
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM Detalle_Orden;
END
GO

-- 6. Lógica de negocio: detalle completo de una orden, línea por línea (usa WHILE)
IF OBJECT_ID('sp_DetalleOrden_ReporteOrden') IS NOT NULL DROP PROCEDURE sp_DetalleOrden_ReporteOrden;
GO
CREATE PROCEDURE sp_DetalleOrden_ReporteOrden @id_orden NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Filas TABLE (Fila INT IDENTITY(1,1), id_producto NVARCHAR(20), cantidad INT, precio_unitario DECIMAL(10,2));
    INSERT INTO @Filas (id_producto, cantidad, precio_unitario)
    SELECT id_producto, cantidad, precio_unitario FROM Detalle_Orden WHERE id_orden = @id_orden;

    DECLARE @i INT = 1, @Max INT = (SELECT COUNT(*) FROM @Filas);
    DECLARE @Resultado TABLE (id_producto NVARCHAR(20), cantidad INT, LineaTotal DECIMAL(10,2));

    WHILE @i <= @Max
    BEGIN
        INSERT INTO @Resultado
        SELECT id_producto, cantidad, cantidad * precio_unitario
        FROM @Filas WHERE Fila = @i;
        SET @i = @i + 1;
    END

    SELECT * FROM @Resultado;
    SELECT dbo.fn_CalcularTotalOrden(@id_orden) AS TotalOrden;
END
GO

-- 7. Lógica de negocio: recalcular subtotales de una orden completa según precio actual del producto (usa WHILE)
IF OBJECT_ID('sp_DetalleOrden_ActualizarPrecios') IS NOT NULL DROP PROCEDURE sp_DetalleOrden_ActualizarPrecios;
GO
CREATE PROCEDURE sp_DetalleOrden_ActualizarPrecios @id_orden NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @Lineas TABLE (Fila INT IDENTITY(1,1), id_producto NVARCHAR(20));
        INSERT INTO @Lineas (id_producto)
        SELECT id_producto FROM Detalle_Orden WHERE id_orden = @id_orden;

        DECLARE @i INT = 1, @Max INT = (SELECT COUNT(*) FROM @Lineas), @Prod NVARCHAR(20), @PrecioActual DECIMAL(10,2), @Cant INT;

        WHILE @i <= @Max
        BEGIN
            SELECT @Prod = id_producto FROM @Lineas WHERE Fila = @i;
            SELECT @PrecioActual = precio FROM Producto WHERE id_producto = @Prod;
            SELECT @Cant = cantidad FROM Detalle_Orden WHERE id_orden = @id_orden AND id_producto = @Prod;

            UPDATE Detalle_Orden
            SET precio_unitario = @PrecioActual, subtotal = @Cant * @PrecioActual
            WHERE id_orden = @id_orden AND id_producto = @Prod;

            SET @i = @i + 1;
        END

        COMMIT TRANSACTION;
        SELECT @Max AS LineasActualizadas;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- =========================================================
-- VISTAS - DETALLE_ORDEN (2)
-- =========================================================
IF OBJECT_ID('vw_DetalleOrden_Completo') IS NOT NULL DROP VIEW vw_DetalleOrden_Completo;
GO
CREATE VIEW vw_DetalleOrden_Completo AS
SELECT d.id_orden, p.nombre_producto, d.cantidad, d.precio_unitario, d.subtotal
FROM Detalle_Orden d
INNER JOIN Producto p ON d.id_producto = p.id_producto;
GO

IF OBJECT_ID('vw_DetalleOrden_LineasAltoValor') IS NOT NULL DROP VIEW vw_DetalleOrden_LineasAltoValor;
GO
CREATE VIEW vw_DetalleOrden_LineasAltoValor AS
SELECT d.id_orden, c.nombre + ' ' + c.apellido AS Cliente, p.nombre_producto, d.cantidad, d.subtotal
FROM Detalle_Orden d
INNER JOIN Orden o ON d.id_orden = o.id_orden
INNER JOIN Cliente c ON o.id_cliente = c.id_cliente
INNER JOIN Producto p ON d.id_producto = p.id_producto
WHERE d.subtotal > 20;
GO

-- =========================================================
-- TRIGGERS - DETALLE_ORDEN (3, 2 con manejo de excepciones)
-- =========================================================

IF OBJECT_ID('TR_DetalleOrden_ActualizarTotalOrden') IS NOT NULL DROP TRIGGER TR_DetalleOrden_ActualizarTotalOrden;
GO
CREATE TRIGGER TR_DetalleOrden_ActualizarTotalOrden
ON Detalle_Orden
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @id_orden NVARCHAR(20);

        IF EXISTS (SELECT 1 FROM inserted)
            SELECT TOP 1 @id_orden = id_orden FROM inserted;
        ELSE
            SELECT TOP 1 @id_orden = id_orden FROM deleted;

        UPDATE Orden
        SET total = dbo.fn_CalcularTotalOrden(@id_orden)
        WHERE id_orden = @id_orden;

        INSERT INTO Auditoria_DetalleOrden (id_orden, id_producto, accion, usuario_bd)
        SELECT ISNULL(i.id_orden, d.id_orden), ISNULL(i.id_producto, d.id_producto),
               CASE WHEN i.id_orden IS NOT NULL AND d.id_orden IS NOT NULL THEN 'UPDATE'
                    WHEN i.id_orden IS NOT NULL THEN 'INSERT' ELSE 'DELETE' END,
               SYSTEM_USER
        FROM inserted i FULL OUTER JOIN deleted d ON i.id_orden = d.id_orden AND i.id_producto = d.id_producto;
    END TRY
    BEGIN CATCH
        PRINT 'Error en TR_DetalleOrden_ActualizarTotalOrden: ' + ERROR_MESSAGE();
    END CATCH
END
GO

-- 2. INSTEAD OF: valida stock antes de insertar la línea de detalle
IF OBJECT_ID('TR_DetalleOrden_ValidarStock') IS NOT NULL DROP TRIGGER TR_DetalleOrden_ValidarStock;
GO
CREATE TRIGGER TR_DetalleOrden_ValidarStock
ON Detalle_Orden
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (
            SELECT 1 FROM inserted i
            INNER JOIN Producto p ON i.id_producto = p.id_producto
            WHERE p.stock < i.cantidad
        )
        BEGIN
            RAISERROR('Stock insuficiente para uno o más productos de la orden.', 16, 1);
            RETURN;
        END
        INSERT INTO Detalle_Orden (id_orden, id_producto, cantidad, precio_unitario, subtotal)
        SELECT id_orden, id_producto, cantidad, precio_unitario, subtotal FROM inserted;
    END TRY
    BEGIN CATCH
        PRINT 'Error en TR_DetalleOrden_ValidarStock: ' + ERROR_MESSAGE();
    END CATCH
END
GO

-- 3. AFTER INSERT: descuenta stock y registra el movimiento de salida en inventario
IF OBJECT_ID('TR_DetalleOrden_DescontarStock') IS NOT NULL DROP TRIGGER TR_DetalleOrden_DescontarStock;
GO
CREATE TRIGGER TR_DetalleOrden_DescontarStock
ON Detalle_Orden
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE p
    SET p.stock = p.stock - i.cantidad
    FROM Producto p
    INNER JOIN inserted i ON p.id_producto = i.id_producto;

    INSERT INTO Inventario_Movimientos (id_mov, id_producto, tipo_movimiento, cantidad, fecha_movimiento, descripcion)
    SELECT 'MOV_' + CONVERT(NVARCHAR(20), NEWID()), id_producto, 'Salida', cantidad, GETDATE(),
           'Venta ' + id_orden
    FROM inserted;
END
GO

-- =========================================================
-- CONSULTAS (3) - con datos reales
-- =========================================================

-- 1. Total y promedio de líneas de venta por producto (SUM, AVG)
SELECT p.nombre_producto, SUM(d.subtotal) AS TotalVendido, AVG(d.subtotal) AS PromedioLinea
FROM Detalle_Orden d INNER JOIN Producto p ON d.id_producto = p.id_producto
GROUP BY p.nombre_producto;

-- 2. Verifica si existe alguna línea con cantidad mayor a 3
IF EXISTS (SELECT 1 FROM Detalle_Orden WHERE cantidad > 3)
    PRINT 'Existen líneas de detalle con cantidad mayor a 3.';
ELSE
    PRINT 'No hay líneas con cantidad mayor a 3.';

-- 3. Productos vendidos junto con su franquicia (JOIN triple)
SELECT d.id_orden, p.nombre_producto, f.nombre_franquicia, d.cantidad, d.subtotal
FROM Detalle_Orden d
INNER JOIN Producto p ON d.id_producto = p.id_producto
LEFT JOIN Franquicia f ON p.id_franquicia = f.id_franquicia;