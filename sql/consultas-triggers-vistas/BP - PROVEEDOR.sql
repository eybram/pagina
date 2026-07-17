/* PROCEDIMIENTOS PROVEEDOR */

--1 Procedimiento almacenado para ingresar datos a cada una de las tablas

IF OBJECT_ID('SP_Proveedor_Insertar') IS NOT NULL
    DROP PROCEDURE SP_Proveedor_Insertar;
GO

CREATE PROCEDURE SP_Proveedor_Insertar
    @id_proveedor NVARCHAR(20), 
    @nombre_proveedor NVARCHAR(100), 
    @contacto NVARCHAR(50),
    @telefono NVARCHAR(30), 
    @pais NVARCHAR(50), 
    @correo NVARCHAR(100)

AS
BEGIN

    INSERT INTO Proveedor (id_proveedor, nombre_proveedor, contacto, telefono, pais, correo)
    VALUES (@id_proveedor, @nombre_proveedor, @contacto, @telefono, @pais, @correo);

END
GO


--2 Procedimiento almacenado para hacer actualización de campos a cada una de las tablas
IF OBJECT_ID('SP_Proveedor_Actualizar') IS NOT NULL
    DROP PROCEDURE SP_Proveedor_Actualizar;
GO

CREATE OR ALTER PROCEDURE SP_Proveedor_Actualizar
    @id_proveedor NVARCHAR(20), 
    @nombre_proveedor NVARCHAR(100), 
    @contacto NVARCHAR(50),
    @telefono NVARCHAR(30), 
    @pais NVARCHAR(50), 
    @correo NVARCHAR(100)
AS
BEGIN

    UPDATE Proveedor
    SET nombre_proveedor = @nombre_proveedor, 
    contacto = @contacto,
    telefono = @telefono, 
    pais = @pais, 
    correo = @correo

    WHERE id_proveedor = @id_proveedor;

END
GO


--3 Procedimiento almacenado para borrar una fila o registro por su llave primaria
IF OBJECT_ID('SP_Proveedor_Eliminar') IS NOT NULL
    DROP PROCEDURE SP_Proveedor_Eliminar;
GO

CREATE PROCEDURE SP_Proveedor_Eliminar
    @id_proveedor NVARCHAR(20)
AS
BEGIN

    DELETE FROM Proveedor WHERE id_proveedor = @id_proveedor;

END
GO

--4 Procedimiento almacenado para realizar una búsqueda de un registro utilizando su llave primaria
IF OBJECT_ID('SP_Proveedor_BuscarPorId') IS NOT NULL
    DROP PROCEDURE SP_Proveedor_BuscarPorId;
GO

CREATE PROCEDURE SP_Proveedor_BuscarPorId
    @id_proveedor NVARCHAR(20)
AS
BEGIN

    SELECT * FROM Proveedor WHERE id_proveedor = @id_proveedor;

END
GO


--5 Procedimiento almacenado que me devuelva todos los registros de la tabla
IF OBJECT_ID('SP_Proveedor_ListarTodos') IS NOT NULL
    DROP PROCEDURE SP_Proveedor_ListarTodos;
GO

CREATE PROCEDURE SP_Proveedor_ListarTodos
AS
BEGIN

    SELECT * FROM Proveedor ORDER BY nombre_proveedor;

END
GO
 
/*Procedimientos de acurdo a la lógica del negocio*/

--6 Procedimiento que devuelve los productos que suministra un proveedor específico
IF OBJECT_ID('SP_Proveedor_ProductosSuministrados') IS NOT NULL
    DROP PROCEDURE SP_Proveedor_ProductosSuministrados;
GO

CREATE PROCEDURE SP_Proveedor_ProductosSuministrados
    @id_proveedor NVARCHAR(20)
AS
BEGIN

    SELECT p.nombre_producto, c.nombre_categoria, p.precio, p.stock
    FROM Producto p
    JOIN Categoria c ON c.id_categoria = p.id_categoria
    
    WHERE p.id_proveedor = @id_proveedor;

END
GO
-- Productos que suministra el proveedor EM1
EXEC SP_Proveedor_ProductosSuministrados @id_proveedor = 'EM1';




--7 Procedimiento que calcula el valor de inventario que aporta cada proveedor
IF OBJECT_ID('SP_Proveedor_ResumenInventario') IS NOT NULL
    DROP PROCEDURE SP_Proveedor_ResumenInventario;
GO

CREATE PROCEDURE SP_Proveedor_ResumenInventario
AS
BEGIN

    DECLARE @contador INT = 1;
    DECLARE @total INT = (SELECT COUNT(*) FROM Proveedor);
    DECLARE @ids TABLE (fila INT IDENTITY(1,1), id_proveedor NVARCHAR(20));
    DECLARE @resultado TABLE (id_proveedor NVARCHAR(20), nombre_proveedor NVARCHAR(100), valor_inventario DECIMAL(12,2));

    INSERT INTO @ids (id_proveedor) SELECT id_proveedor FROM Proveedor;

    WHILE @contador <= @total
    BEGIN
        INSERT INTO @resultado
        SELECT pr.id_proveedor, pr.nombre_proveedor, ISNULL(SUM(p.precio * p.stock), 0)
        FROM Proveedor pr
        LEFT JOIN Producto p ON p.id_proveedor = pr.id_proveedor
        WHERE pr.id_proveedor = (SELECT id_proveedor FROM @ids WHERE fila = @contador)
        GROUP BY pr.id_proveedor, pr.nombre_proveedor;

        SET @contador += 1;
    END

    SELECT * FROM @resultado ORDER BY valor_inventario DESC;
END
GO

-- Resumen de valor de inventario por proveedor (usa WHILE)
EXEC SP_Proveedor_ResumenInventario;



/*Pruebas*/

-- Insertar proveedor de prueba
EXEC SP_Proveedor_Insertar
    @id_proveedor = 'EMTest', @nombre_proveedor = 'Prueba Import',
    @contacto = 'Juan Perez', @telefono = '6555-0000',
    @pais = 'Panamá', @correo = 'contacto@pruebaimport.com';
 
-- Buscar el proveedor insertado
EXEC SP_Proveedor_BuscarPorId @id_proveedor = 'EMTest';
 
-- Actualizar el proveedor
EXEC SP_Proveedor_Actualizar
    @id_proveedor = 'EMTest', @nombre_proveedor = 'Prueba Import S.A.',
    @contacto = 'Juan Perez', @telefono = '6555-1234',
    @pais = 'Panamá', @correo = 'ventas@pruebaimport.com';
 
-- Listar todos los proveedores
EXEC SP_Proveedor_ListarTodos;
 
-- Eliminar el proveedor de prueba
EXEC SP_Proveedor_Eliminar @id_proveedor = 'EMTest';


/*VISTAS*/

--1 Vista que muestra cada proveedor con la cantidad de productos que suministra
IF OBJECT_ID('VW_Proveedores_Catalogo') IS NOT NULL
    DROP VIEW VW_Proveedores_Catalogo;
GO

CREATE VIEW VW_Proveedores_Catalogo 
AS
SELECT pr.id_proveedor, pr.nombre_proveedor, pr.pais, COUNT(p.id_producto) AS cantidad_productos
FROM Proveedor pr
LEFT JOIN Producto p ON p.id_proveedor = pr.id_proveedor
GROUP BY pr.id_proveedor, pr.nombre_proveedor, pr.pais;
GO

--exc
SELECT * FROM VW_Proveedores_Catalogo;

--2 Vista que filtra los proveedores ubicados fuera de Panamá
IF OBJECT_ID('VW_Proveedores_PaisExtranjero') IS NOT NULL
    DROP VIEW VW_Proveedores_PaisExtranjero;
GO

CREATE VIEW VW_Proveedores_PaisExtranjero 
AS
SELECT id_proveedor, nombre_proveedor, pais, correo
FROM Proveedor
WHERE pais not like 'Panamá';
GO
--exc
SELECT * FROM VW_Proveedores_PaisExtranjero;
