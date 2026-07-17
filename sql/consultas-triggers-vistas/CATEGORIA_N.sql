-- =============================================
-- PROCEDIMIENTOS ALMACENADOS - CATEGORIA
-- =============================================

-- 1. Insertar Categoría
CREATE PROCEDURE sp_InsertarCategoria
    @id NVARCHAR(20),
    @nombre NVARCHAR(50),
    @descripcion NVARCHAR(150)
AS
BEGIN
    INSERT INTO Categoria
    VALUES(@id,@nombre,@descripcion);
END;
GO

-- 2. Mostrar Categorías
CREATE PROCEDURE sp_MostrarCategorias
AS
BEGIN
    SELECT * FROM Categoria;
END;
GO

-- 3. Buscar Categoría por ID
CREATE PROCEDURE sp_BuscarCategoria
    @id NVARCHAR(20)
AS
BEGIN
    SELECT *
    FROM Categoria
    WHERE id_categoria=@id;
END;
GO

-- 4. Actualizar Categoría
CREATE PROCEDURE sp_ActualizarCategoria
    @id NVARCHAR(20),
    @nombre NVARCHAR(50),
    @descripcion NVARCHAR(150)
AS
BEGIN
    UPDATE Categoria
    SET nombre_categoria=@nombre,
        descripcion=@descripcion
    WHERE id_categoria=@id;
END;
GO

-- 5. Eliminar Categoría
CREATE PROCEDURE sp_EliminarCategoria
    @id NVARCHAR(20)
AS
BEGIN
    DELETE FROM Categoria
    WHERE id_categoria=@id;
END;
GO

-- 6. Contar Categorías
CREATE PROCEDURE sp_ContarCategorias
AS
BEGIN
    SELECT COUNT(*) AS TotalCategorias
    FROM Categoria;
END;
GO

-- 7. Buscar Categoría por Nombre
CREATE PROCEDURE sp_BuscarCategoriaNombre
    @nombre NVARCHAR(50)
AS
BEGIN
    SELECT *
    FROM Categoria
    WHERE nombre_categoria LIKE '%' + @nombre + '%';
END;
GO

-- =============================================
-- VISTAS - CATEGORIA
-- =============================================

-- Vista 1
CREATE VIEW vw_Categorias
AS
SELECT
    id_categoria,
    nombre_categoria,
    descripcion
FROM Categoria;
GO

-- Vista 2
CREATE VIEW vw_CategoriasProductos
AS
SELECT
    C.nombre_categoria,
    COUNT(P.id_producto) AS CantidadProductos
FROM Categoria C
LEFT JOIN Producto P
ON C.id_categoria = P.id_categoria
GROUP BY C.nombre_categoria;
GO
