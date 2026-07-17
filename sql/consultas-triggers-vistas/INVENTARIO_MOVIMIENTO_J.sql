USE [Broken Pocket]
GO

-- 1. PROCEDIMIENTO: Insertar en Inventario_Movimientos
DROP PROCEDURE IF EXISTS sp_InvMov_Insertar;
GO
CREATE OR ALTER PROCEDURE sp_InvMov_Insertar
    @id_mov NVARCHAR(20), @id_producto NVARCHAR(20), @tipo NVARCHAR(20), @cantidad INT, @desc NVARCHAR(200)
AS
BEGIN
    INSERT INTO Inventario_Movimientos (id_mov, id_producto, tipo_movimiento, cantidad, fecha_movimiento, descripcion)
    VALUES (@id_mov, @id_producto, @tipo, @cantidad, GETDATE(), @desc)
END
GO

-- 2. PROCEDIMIENTO: Actualizar Inventario_Movimientos

DROP PROCEDURE IF EXISTS sp_InvMov_Actualizar;
GO
CREATE OR ALTER PROCEDURE sp_InvMov_Actualizar
    @id_mov NVARCHAR(20), @cantidad INT, @desc NVARCHAR(200)
AS
BEGIN
    UPDATE Inventario_Movimientos SET cantidad = @cantidad, descripcion = @desc WHERE id_mov = @id_mov
END
GO

-- 3. PROCEDIMIENTO: Borrar registro

DROP PROCEDURE IF EXISTS sp_InvMov_Eliminar;
GO
CREATE OR ALTER PROCEDURE sp_InvMov_Eliminar
    @id_mov NVARCHAR(20)
AS
BEGIN
    DELETE FROM Inventario_Movimientos WHERE id_mov = @id_mov
END
GO

-- 4. PROCEDIMIENTO: Buscar por ID

DROP PROCEDURE IF EXISTS sp_InvMov_Buscar;
GO
CREATE OR ALTER PROCEDURE sp_InvMov_Buscar
    @id_mov NVARCHAR(20)
AS
BEGIN
    SELECT * FROM Inventario_Movimientos WHERE id_mov = @id_mov
END
GO

-- 5. PROCEDIMIENTO: Listar todo

DROP PROCEDURE IF EXISTS sp_InvMov_Listar;
GO
CREATE OR ALTER PROCEDURE sp_InvMov_Listar
AS
BEGIN
    SELECT * FROM Inventario_Movimientos
END
GO

-- 6. PROCEDIMIENTO: Lógica de Negocio (While - Calcular total entradas)

DROP PROCEDURE IF EXISTS sp_InvMov_CalcularTotalEntradas;
GO
CREATE OR ALTER PROCEDURE sp_InvMov_CalcularTotalEntradas
AS
BEGIN
    DECLARE @total INT = 0;
    DECLARE @cant INT;
    DECLARE cur CURSOR FOR SELECT cantidad FROM Inventario_Movimientos WHERE tipo_movimiento = 'Entrada';
    OPEN cur;
    FETCH NEXT FROM cur INTO @cant;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @total = @total + @cant;
        FETCH NEXT FROM cur INTO @cant;
    END
    CLOSE cur; DEALLOCATE cur;
    SELECT @total AS Total_Entradas_Registradas;
END
GO

-- 7. PROCEDIMIENTO: Lógica de Negocio (While - Listar Movimientos grandes)

DROP PROCEDURE IF EXISTS sp_InvMov_ListarMovimientosGrandes;
GO
CREATE OR ALTER PROCEDURE sp_InvMov_ListarMovimientosGrandes
    @limite INT
AS
BEGIN
    DECLARE @id NVARCHAR(20), @cant INT;
    DECLARE cur CURSOR FOR SELECT id_mov, cantidad FROM Inventario_Movimientos;
    OPEN cur;
    FETCH NEXT FROM cur INTO @id, @cant;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @cant > @limite
            PRINT 'Movimiento ' + @id + ' excede límite con cantidad: ' + CAST(@cant AS VARCHAR);
        FETCH NEXT FROM cur INTO @id, @cant;
    END
    CLOSE cur; DEALLOCATE cur;
END
GO

--------------------------  VISTAS --------------------

CREATE VIEW vw_InvMov_ReporteEntradas AS
SELECT * FROM Inventario_Movimientos WHERE tipo_movimiento = 'Entrada';
GO

CREATE VIEW vw_InvMov_ReporteSalidas AS
SELECT * FROM Inventario_Movimientos WHERE tipo_movimiento = 'Salida';
GO



---------------- CONTROL DE CONCURRENCIA ------------------

CREATE OR ALTER PROCEDURE sp_InvMov_TransaccionSegura
    @id_mov NVARCHAR(20), @id_prod NVARCHAR(20), @cant INT
AS
BEGIN
    BEGIN TRANSACTION
        -- Lectura con NOLOCK para reportes
        SELECT COUNT(*) FROM Inventario_Movimientos WITH (NOLOCK);
        
        -- Inserción
        INSERT INTO Inventario_Movimientos (id_mov, id_producto, tipo_movimiento, cantidad)
        VALUES (@id_mov, @id_prod, 'Entrada', @cant);
    COMMIT TRANSACTION
END
GO

