-- =============================================
-- PROCEDIMIENTOS ALMACENADOS - FRANQUICIA
-- =============================================

-- 1. Insertar Franquicia
CREATE PROCEDURE sp_InsertarFranquicia
    @id NVARCHAR(20),
    @nombre NVARCHAR(50),
    @matriz NVARCHAR(50)
AS
BEGIN
    INSERT INTO Franquicia
    VALUES(@id,@nombre,@matriz);
END;
GO

-- 2. Mostrar Franquicias
CREATE PROCEDURE sp_MostrarFranquicias
AS
BEGIN
    SELECT * FROM Franquicia;
END;
GO

-- 3. Buscar Franquicia por ID
CREATE PROCEDURE sp_BuscarFranquicia
    @id NVARCHAR(20)
AS
BEGIN
    SELECT *
    FROM Franquicia
    WHERE id_franquicia=@id;
END;
GO

-- 4. Actualizar Franquicia
CREATE PROCEDURE sp_ActualizarFranquicia
    @id NVARCHAR(20),
    @nombre NVARCHAR(50),
    @matriz NVARCHAR(50)
AS
BEGIN
    UPDATE Franquicia
    SET nombre_franquicia=@nombre,
        casa_matriz=@matriz
    WHERE id_franquicia=@id;
END;
GO

-- 5. Eliminar Franquicia
CREATE PROCEDURE sp_EliminarFranquicia
    @id NVARCHAR(20)
AS
BEGIN
    DELETE FROM Franquicia
    WHERE id_franquicia=@id;
END;
GO

-- 6. Contar Franquicias
CREATE PROCEDURE sp_ContarFranquicias
AS
BEGIN
    SELECT COUNT(*) AS TotalFranquicias
    FROM Franquicia;
END;
GO

-- 7. Buscar por Casa Matriz
CREATE PROCEDURE sp_BuscarCasaMatriz
    @matriz NVARCHAR(50)
AS
BEGIN
    SELECT *
    FROM Franquicia
    WHERE casa_matriz LIKE '%' + @matriz + '%';
END;
GO

-- =============================================
-- VISTAS - FRANQUICIA
-- =============================================

-- Vista 1
CREATE VIEW vw_Franquicias
AS
SELECT
    id_franquicia,
    nombre_franquicia,
    casa_matriz
FROM Franquicia;
GO

-- Vista 2
CREATE VIEW vw_FranquiciasProductos
AS
SELECT
    F.nombre_franquicia,
    COUNT(P.id_producto) AS Productos
FROM Franquicia F
LEFT JOIN Producto P
ON F.id_franquicia = P.id_franquicia
GROUP BY F.nombre_franquicia;
GO