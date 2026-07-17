USE [Broken Pocket]
GO

-- =========================================================
-- TABLA DE AUDITORÍA - ORDEN
-- =========================================================
IF OBJECT_ID('Auditoria_Orden') IS NOT NULL DROP TABLE Auditoria_Orden;
GO
CREATE TABLE Auditoria_Orden (
    id_auditoria    INT IDENTITY(1,1) PRIMARY KEY,
    id_orden        NVARCHAR(20),
    accion          NVARCHAR(10),
    usuario_bd      NVARCHAR(100),
    fecha_accion    DATETIME DEFAULT GETDATE(),
    detalle         NVARCHAR(200)
);
GO

-- =========================================================
-- FUNCIONES DEFINIDAS POR EL USUARIO (Joel - 2 funciones)
-- =========================================================
IF OBJECT_ID('fn_CalcularTotalOrden') IS NOT NULL DROP FUNCTION fn_CalcularTotalOrden;
GO
CREATE FUNCTION fn_CalcularTotalOrden(@id_orden NVARCHAR(20))
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Total DECIMAL(10,2);
    SELECT @Total = SUM(subtotal)
    FROM Detalle_Orden
    WHERE id_orden = @id_orden;
    RETURN ISNULL(@Total, 0);
END
GO

IF OBJECT_ID('fn_ContarProductosOrden') IS NOT NULL DROP FUNCTION fn_ContarProductosOrden;
GO
CREATE FUNCTION fn_ContarProductosOrden(@id_orden NVARCHAR(20))
RETURNS INT
AS
BEGIN
    DECLARE @Cant INT;
    SELECT @Cant = COUNT(*) FROM Detalle_Orden WHERE id_orden = @id_orden;
    RETURN ISNULL(@Cant, 0);
END
GO

-- =========================================================
-- PROCEDIMIENTOS ALMACENADOS - ORDEN (7)
-- =========================================================

-- 1. Insertar
IF OBJECT_ID('sp_Orden_Insertar') IS NOT NULL DROP PROCEDURE sp_Orden_Insertar;
GO
CREATE PROCEDURE sp_Orden_Insertar
    @id_orden NVARCHAR(20), @id_cliente NVARCHAR(20), @id_empleado NVARCHAR(20),
    @fecha_orden DATE = NULL, @total DECIMAL(10,2), @metodo_pago NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Cliente WHERE id_cliente = @id_cliente)
    BEGIN
        RAISERROR('El cliente no existe.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM Empleado WHERE id_empleado = @id_empleado)
    BEGIN
        RAISERROR('El empleado no existe.', 16, 1);
        RETURN;
    END
    INSERT INTO Orden (id_orden, id_cliente, id_empleado, fecha_orden, total, metodo_pago)
    VALUES (@id_orden, @id_cliente, @id_empleado, ISNULL(@fecha_orden, GETDATE()), @total, @metodo_pago);
END
GO

-- 2. Actualizar
IF OBJECT_ID('sp_Orden_Actualizar') IS NOT NULL DROP PROCEDURE sp_Orden_Actualizar;
GO
CREATE PROCEDURE sp_Orden_Actualizar
    @id_orden NVARCHAR(20), @total DECIMAL(10,2), @metodo_pago NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Orden WHERE id_orden = @id_orden)
    BEGIN
        RAISERROR('La orden no existe.', 16, 1);
        RETURN;
    END
    UPDATE Orden
    SET total = @total, metodo_pago = @metodo_pago
    WHERE id_orden = @id_orden;
END
GO

-- 3. Eliminar por PK
IF OBJECT_ID('sp_Orden_Eliminar') IS NOT NULL DROP PROCEDURE sp_Orden_Eliminar;
GO
CREATE PROCEDURE sp_Orden_Eliminar @id_orden NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Orden WHERE id_orden = @id_orden)
    BEGIN
        RAISERROR('La orden no existe.', 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM Detalle_Orden WHERE id_orden = @id_orden)
    BEGIN
        RAISERROR('No se puede eliminar: la orden tiene detalles asociados.', 16, 1);
        RETURN;
    END
    DELETE FROM Orden WHERE id_orden = @id_orden;
END
GO

-- 4. Buscar por PK
IF OBJECT_ID('sp_Orden_BuscarPorID') IS NOT NULL DROP PROCEDURE sp_Orden_BuscarPorID;
GO
CREATE PROCEDURE sp_Orden_BuscarPorID @id_orden NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM Orden WHERE id_orden = @id_orden;
END
GO

-- 5. Obtener todos
IF OBJECT_ID('sp_Orden_ObtenerTodos') IS NOT NULL DROP PROCEDURE sp_Orden_ObtenerTodos;
GO
CREATE PROCEDURE sp_Orden_ObtenerTodos
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM Orden ORDER BY fecha_orden DESC;
END
GO

-- 6. Lógica de negocio: historial de un cliente con total recalculado por función (usa cursor + WHILE)
IF OBJECT_ID('sp_Orden_HistorialCliente') IS NOT NULL DROP PROCEDURE sp_Orden_HistorialCliente;
GO
CREATE PROCEDURE sp_Orden_HistorialCliente @id_cliente NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @TablaTemp TABLE (id_orden NVARCHAR(20), TotalCalculado DECIMAL(10,2), CantProductos INT);
    DECLARE @OrdenActual NVARCHAR(20);

    DECLARE cur CURSOR LOCAL FOR SELECT id_orden FROM Orden WHERE id_cliente = @id_cliente;
    OPEN cur;
    FETCH NEXT FROM cur INTO @OrdenActual;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO @TablaTemp
        VALUES (@OrdenActual, dbo.fn_CalcularTotalOrden(@OrdenActual), dbo.fn_ContarProductosOrden(@OrdenActual));
        FETCH NEXT FROM cur INTO @OrdenActual;
    END
    CLOSE cur; DEALLOCATE cur;

    SELECT o.id_orden, o.fecha_orden, o.metodo_pago, t.TotalCalculado, t.CantProductos
    FROM Orden o INNER JOIN @TablaTemp t ON o.id_orden = t.id_orden
    ORDER BY o.fecha_orden DESC;
END
GO

-- 7. Lógica de negocio: recalcular el total real de cada orden en un rango de fechas (usa WHILE + TRY/CATCH)
IF OBJECT_ID('sp_Orden_RecalcularTotalesLote') IS NOT NULL DROP PROCEDURE sp_Orden_RecalcularTotalesLote;
GO
CREATE PROCEDURE sp_Orden_RecalcularTotalesLote @FechaDesde DATE, @FechaHasta DATE
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @Ordenes TABLE (Fila INT IDENTITY(1,1), id_orden NVARCHAR(20));
        INSERT INTO @Ordenes (id_orden)
        SELECT id_orden FROM Orden
        WHERE fecha_orden BETWEEN @FechaDesde AND @FechaHasta;

        DECLARE @i INT = 1, @Max INT = (SELECT COUNT(*) FROM @Ordenes), @IdActual NVARCHAR(20);

        WHILE @i <= @Max
        BEGIN
            SELECT @IdActual = id_orden FROM @Ordenes WHERE Fila = @i;
            UPDATE Orden SET total = dbo.fn_CalcularTotalOrden(@IdActual) WHERE id_orden = @IdActual;
            SET @i = @i + 1;
        END

        COMMIT TRANSACTION;
        SELECT @Max AS OrdenesActualizadas;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- =========================================================
-- VISTAS - ORDEN (2)
-- =========================================================
IF OBJECT_ID('vw_Orden_Resumen') IS NOT NULL DROP VIEW vw_Orden_Resumen;
GO
CREATE VIEW vw_Orden_Resumen AS
SELECT o.id_orden, c.nombre + ' ' + c.apellido AS Cliente, e.nombre + ' ' + e.apellido AS Empleado,
       o.fecha_orden, o.metodo_pago, o.total
FROM Orden o
INNER JOIN Cliente c ON o.id_cliente = c.id_cliente
INNER JOIN Empleado e ON o.id_empleado = e.id_empleado;
GO

IF OBJECT_ID('vw_Orden_VentasAltas') IS NOT NULL DROP VIEW vw_Orden_VentasAltas;
GO
CREATE VIEW vw_Orden_VentasAltas AS
SELECT o.id_orden, c.nombre + ' ' + c.apellido AS Cliente, e.cargo AS AtendidoPor,
       o.fecha_orden, o.total
FROM Orden o
INNER JOIN Cliente c ON o.id_cliente = c.id_cliente
INNER JOIN Empleado e ON o.id_empleado = e.id_empleado
WHERE o.total > 30;
GO

-- =========================================================
-- TRIGGER - ORDEN (auditoría, con manejo de excepciones)
-- =========================================================
IF OBJECT_ID('TR_Orden_Auditoria') IS NOT NULL DROP TRIGGER TR_Orden_Auditoria;
GO
CREATE TRIGGER TR_Orden_Auditoria
ON Orden
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
            INSERT INTO Auditoria_Orden (id_orden, accion, usuario_bd, detalle)
            SELECT id_orden, 'UPDATE', SYSTEM_USER, 'Orden actualizada' FROM inserted;
        ELSE IF EXISTS (SELECT 1 FROM inserted)
            INSERT INTO Auditoria_Orden (id_orden, accion, usuario_bd, detalle)
            SELECT id_orden, 'INSERT', SYSTEM_USER, 'Orden creada' FROM inserted;
        ELSE
            INSERT INTO Auditoria_Orden (id_orden, accion, usuario_bd, detalle)
            SELECT id_orden, 'DELETE', SYSTEM_USER, 'Orden eliminada' FROM deleted;
    END TRY
    BEGIN CATCH
        PRINT 'Error en TR_Orden_Auditoria: ' + ERROR_MESSAGE();
    END CATCH
END
GO

-- =========================================================
-- CONSULTAS (3) - con datos reales
-- =========================================================

-- 1. Total y promedio gastado por cliente (SUM, AVG)
SELECT c.nombre + ' ' + c.apellido AS Cliente, SUM(o.total) AS TotalGastado, AVG(o.total) AS PromedioOrden
FROM Orden o INNER JOIN Cliente c ON o.id_cliente = c.id_cliente
GROUP BY c.nombre, c.apellido;

-- 2. Verifica si existe alguna orden con más de 2 productos distintos
IF EXISTS (
    SELECT 1 FROM Detalle_Orden
    GROUP BY id_orden HAVING COUNT(id_producto) > 2
)
    PRINT 'Existen órdenes con más de 2 productos distintos.';
ELSE
    PRINT 'No hay órdenes con más de 2 productos.';

-- 3. Órdenes pagadas con Yappy o Transferencia (métodos digitales)
SELECT o.id_orden, c.nombre + ' ' + c.apellido AS Cliente, o.metodo_pago, o.total
FROM Orden o INNER JOIN Cliente c ON o.id_cliente = c.id_cliente
WHERE o.metodo_pago IN ('Yappy', 'Transferencia');