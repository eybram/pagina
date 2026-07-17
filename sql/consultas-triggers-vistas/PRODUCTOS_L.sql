use [Broken Pocket]
GO

--1 Procedimiento almacenado para ingresar datos a cada una de las tablas 

-- Verificar que el sp no exista y si existe lo eliminamos
IF OBJECT_ID('sp_InsertarProducto', 'P') IS NOT NULL
    DROP PROCEDURE sp_InsertarProducto;
GO

CREATE PROCEDURE sp_InsertarProducto
    @id_producto     NVARCHAR(20),
    @nombre_producto NVARCHAR(100),
    @id_categoria    NVARCHAR(20),
    @id_franquicia   NVARCHAR(20) = NULL,
    @precio          DECIMAL(10,2),
    @stock           INT = 0,
    @id_proveedor    NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Producto WHERE id_producto = @id_producto)
    BEGIN
        RAISERROR('Ya existe un producto con ese id_producto.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Categoria WHERE id_categoria = @id_categoria)
    BEGIN
        RAISERROR('La categoria indicada no existe.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Proveedor WHERE id_proveedor = @id_proveedor)
    BEGIN
        RAISERROR('El proveedor indicado no existe.', 16, 1);
        RETURN;
    END

    INSERT INTO Producto (id_producto, nombre_producto, id_categoria, id_franquicia, precio, stock, id_proveedor)
    VALUES (@id_producto, @nombre_producto, @id_categoria, @id_franquicia, @precio, @stock, @id_proveedor);
END
GO

-- Prueba 1: insercion exitosa
EXEC sp_InsertarProducto
    @id_producto     = 'PR11',
    @nombre_producto = 'Camiseta de Pokémon',
    @id_categoria    = 'CAT1',
    @id_franquicia   = 'FR3',
    @precio          = 24.00,
    @stock           = 45,
    @id_proveedor    = 'EM2';

SELECT * FROM Producto WHERE id_producto = 'PR11';
GO

-- Prueba 2: id_producto duplicado (debe fallar con mensaje)
EXEC sp_InsertarProducto
    @id_producto     = 'PR1',
    @nombre_producto = 'Duplicado',
    @id_categoria    = 'CAT1',
    @id_franquicia   = 'FR1',
    @precio          = 10.00,
    @stock           = 5,
    @id_proveedor    = 'EM1';
GO

-- Prueba 3: id_categoria inexistente (debe fallar con mensaje)
EXEC sp_InsertarProducto
    @id_producto     = 'PR12',
    @nombre_producto = 'Producto invalido',
    @id_categoria    = 'CAT99',
    @id_franquicia   = NULL,
    @precio          = 15.00,
    @stock           = 10,
    @id_proveedor    = 'EM1';
GO

-- Prueba 4: id_proveedor inexistente (debe fallar con mensaje)
EXEC sp_InsertarProducto
    @id_producto     = 'PR13',
    @nombre_producto = 'Producto invalido 2',
    @id_categoria    = 'CAT1',
    @id_franquicia   = NULL,
    @precio          = 15.00,
    @stock           = 10,
    @id_proveedor    = 'EM99';
GO

-- Prueba 5: sin especificar stock ni franquicia (debe usar los defaults 0 y NULL)
EXEC sp_InsertarProducto
    @id_producto     = 'PR14',
    @nombre_producto = 'Poster generico',
    @id_categoria    = 'CAT4',
    @id_proveedor    = 'EM3';

SELECT * FROM Producto WHERE id_producto = 'PR14';
GO


-- SP 2: Actualizar producto
IF OBJECT_ID('sp_ActualizarProducto', 'P') IS NOT NULL
    DROP PROCEDURE sp_ActualizarProducto;
GO

CREATE PROCEDURE sp_ActualizarProducto
    @id_producto     NVARCHAR(20),
    @nombre_producto NVARCHAR(100) = NULL,
    @id_categoria    NVARCHAR(20)  = NULL,
    @id_franquicia   NVARCHAR(20)  = NULL,
    @precio          DECIMAL(10,2) = NULL,
    @stock           INT           = NULL,
    @id_proveedor    NVARCHAR(20)  = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Producto WHERE id_producto = @id_producto)
    BEGIN
        RAISERROR('No existe un producto con ese id_producto.', 16, 1);
        RETURN;
    END

    IF @id_categoria IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Categoria WHERE id_categoria = @id_categoria)
    BEGIN
        RAISERROR('La categoria indicada no existe.', 16, 1);
        RETURN;
    END

    IF @id_franquicia IS NOT NULL AND @id_franquicia <> '' AND NOT EXISTS (SELECT 1 FROM Franquicia WHERE id_franquicia = @id_franquicia)
    BEGIN
        RAISERROR('La franquicia indicada no existe.', 16, 1);
        RETURN;
    END

    IF @id_proveedor IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Proveedor WHERE id_proveedor = @id_proveedor)
    BEGIN
        RAISERROR('El proveedor indicado no existe.', 16, 1);
        RETURN;
    END

    IF @precio IS NOT NULL AND @precio <= 0
    BEGIN
        RAISERROR('El precio debe ser mayor a cero.', 16, 1);
        RETURN;
    END

    IF @stock IS NOT NULL AND @stock < 0
    BEGIN
        RAISERROR('El stock no puede ser negativo.', 16, 1);
        RETURN;
    END

    UPDATE Producto
    SET nombre_producto = CASE WHEN @nombre_producto IS NOT NULL THEN @nombre_producto ELSE nombre_producto END,
        id_categoria    = CASE WHEN @id_categoria IS NOT NULL THEN @id_categoria ELSE id_categoria END,
        id_franquicia   = CASE WHEN @id_franquicia = '' THEN NULL
                                WHEN @id_franquicia IS NOT NULL THEN @id_franquicia
                                ELSE id_franquicia END,
        precio          = CASE WHEN @precio IS NOT NULL THEN @precio ELSE precio END,
        stock           = CASE WHEN @stock IS NOT NULL THEN @stock ELSE stock END,
        id_proveedor    = CASE WHEN @id_proveedor IS NOT NULL THEN @id_proveedor ELSE id_proveedor END
    WHERE id_producto = @id_producto;
END
GO

--pruebas 

-- Prueba 1: actualizar solo el precio
EXEC sp_ActualizarProducto @id_producto = 'PR11', @precio = 27.50;
SELECT * FROM Producto WHERE id_producto = 'PR11';
GO

-- Prueba 2: actualizar varios campos a la vez
EXEC sp_ActualizarProducto
    @id_producto     = 'PR11',
    @nombre_producto = 'Camiseta Pokémon Edición Especial',
    @stock            = 60;
SELECT * FROM Producto WHERE id_producto = 'PR11';

-- SP 3: Eliminar producto por PK
IF OBJECT_ID('sp_EliminarProducto', 'P') IS NOT NULL
    DROP PROCEDURE sp_EliminarProducto;
GO
CREATE PROCEDURE sp_EliminarProducto
    @id_producto NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Producto WHERE id_producto = @id_producto)
    BEGIN
        RAISERROR('No existe un producto con ese id_producto.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Detalle_Orden WHERE id_producto = @id_producto)
    BEGIN
        RAISERROR('No se puede eliminar: el producto tiene ordenes asociadas.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Inventario_Movimientos WHERE id_producto = @id_producto)
    BEGIN
        RAISERROR('No se puede eliminar: el producto tiene movimientos de inventario asociados.', 16, 1);
        RETURN;
    END

    DELETE FROM Producto WHERE id_producto = @id_producto;
END
GO
-- Prueba eliminar un producto sin dependencias
EXEC sp_InsertarProducto
    @id_producto = 'PR99', @nombre_producto = 'Producto de prueba',
    @id_categoria = 'CAT1', @id_franquicia = NULL,
    @precio = 5.00, @stock = 1, @id_proveedor = 'EM1';

EXEC sp_EliminarProducto @id_producto = 'PR99';
SELECT * FROM Producto WHERE id_producto = 'PR99'; -- debe salir vacio
GO

-- Prueba eliminar un producto CON dependencias (debe fallar)
EXEC sp_EliminarProducto @id_producto = 'PR1';
GO

-- Prueba producto que no existe
EXEC sp_EliminarProducto @id_producto = 'PRXX';
GO

-- SP 4: Buscar producto por PK
IF OBJECT_ID('sp_BuscarProducto', 'P') IS NOT NULL
    DROP PROCEDURE sp_BuscarProducto;
GO
CREATE PROCEDURE sp_BuscarProducto
    @id_producto NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Producto WHERE id_producto = @id_producto)
    BEGIN
        RAISERROR('No existe un producto con ese id_producto.', 16, 1);
        RETURN;
    END

    SELECT * FROM Producto WHERE id_producto = @id_producto;
END
GO

-- Prueba buscar producto existente
EXEC sp_BuscarProducto @id_producto = 'PR3';
GO

-- Prueba buscar producto que no existe
EXEC sp_BuscarProducto @id_producto = 'PRXX';
GO



-- SP 5: Listar todos los productos
IF OBJECT_ID('sp_ListarProductos', 'P') IS NOT NULL
    DROP PROCEDURE sp_ListarProductos;
GO
CREATE PROCEDURE sp_ListarProductos
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM Producto ORDER BY nombre_producto;
END
GO
-- Prueba listar todos
EXEC sp_ListarProductos;
GO

-- SP 6: Aumentar precio por categoria con while
IF OBJECT_ID('sp_AumentarPrecioPorCategoria', 'P') IS NOT NULL
    DROP PROCEDURE sp_AumentarPrecioPorCategoria;
GO
CREATE PROCEDURE sp_AumentarPrecioPorCategoria
    @id_categoria NVARCHAR(20),
    @porcentaje   DECIMAL(5,2)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Categoria WHERE id_categoria = @id_categoria)
    BEGIN
        RAISERROR('La categoria indicada no existe.', 16, 1);
        RETURN;
    END

    IF @porcentaje <= 0
    BEGIN
        RAISERROR('El porcentaje debe ser mayor a cero.', 16, 1);
        RETURN;
    END

    DECLARE @Productos TABLE (Fila INT IDENTITY(1,1), id_producto NVARCHAR(20));
    INSERT INTO @Productos (id_producto)
    SELECT id_producto FROM Producto WHERE id_categoria = @id_categoria;

    DECLARE @Total INT = (SELECT COUNT(*) FROM @Productos);
    DECLARE @Contador INT = 1;
    DECLARE @IdActual NVARCHAR(20);

    WHILE @Contador <= @Total
    BEGIN
        SELECT @IdActual = id_producto FROM @Productos WHERE Fila = @Contador;

        UPDATE Producto
        SET precio = precio * (1 + @porcentaje / 100)
        WHERE id_producto = @IdActual;

        SET @Contador = @Contador + 1;
    END
END
GO

-- Prueba SP 6: aumentar 10% el precio de la categoria CAT2 (Figuras)
SELECT id_producto, precio FROM Producto WHERE id_categoria = 'CAT2';
EXEC sp_AumentarPrecioPorCategoria @id_categoria = 'CAT2', @porcentaje = 10;
SELECT id_producto, precio FROM Producto WHERE id_categoria = 'CAT2';
GO

-- SP 7: Reporte de productos con stock bajo por proveedor 
IF OBJECT_ID('sp_ProductosStockBajoPorProveedor', 'P') IS NOT NULL
    DROP PROCEDURE sp_ProductosStockBajoPorProveedor;
GO
CREATE PROCEDURE sp_ProductosStockBajoPorProveedor
    @stock_minimo INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        p.id_producto,
        p.nombre_producto,
        p.stock,
        c.nombre_categoria,
        f.nombre_franquicia,
        pr.nombre_proveedor,
        pr.correo AS correo_proveedor
    FROM Producto p
    JOIN Categoria c   ON p.id_categoria = c.id_categoria
    JOIN Proveedor pr  ON p.id_proveedor = pr.id_proveedor
    LEFT JOIN Franquicia f ON p.id_franquicia = f.id_franquicia
    WHERE p.stock <= @stock_minimo
    ORDER BY p.stock ASC;
END
GO

-- Prueba SP 7: productos con stock <= 25
EXEC sp_ProductosStockBajoPorProveedor @stock_minimo = 25;
GO


--funciones 

-- Funcion 1: Total de productos con stock disponible
IF OBJECT_ID('fn_TotalProductosActivos', 'FN') IS NOT NULL
    DROP FUNCTION fn_TotalProductosActivos;
GO
CREATE FUNCTION fn_TotalProductosActivos()
RETURNS INT
AS
BEGIN
    DECLARE @Total INT;
    SELECT @Total = COUNT(*) FROM Producto WHERE stock > 0;
    RETURN @Total;
END
GO

select dbo.fn_TotalProductosActivos as totalActivos


-- Funcion 2: Precio con impuesto ITBMS 7% 
IF OBJECT_ID('fn_PrecioConImpuesto', 'FN') IS NOT NULL
    DROP FUNCTION fn_PrecioConImpuesto;
GO
CREATE FUNCTION fn_PrecioConImpuesto(@precio DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @precio * 1.07;
END
GO

select dbo.fn_PrecioConImpuesto(25.00) as PrecioConImpuestos

-- Funcion 3: Valor total en inventario de un producto 
IF OBJECT_ID('fn_ValorInventario', 'FN') IS NOT NULL
    DROP FUNCTION fn_ValorInventario;
GO
CREATE FUNCTION fn_ValorInventario(@id_producto NVARCHAR(20))
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Valor DECIMAL(10,2);
    SELECT @Valor = precio * stock FROM Producto WHERE id_producto = @id_producto;
    RETURN ISNULL(@Valor, 0);
END
GO

SELECT dbo.fn_ValorInventario('PR1') AS ValorInventarioPR1;
GO

-- procedure con funcion 

-- SP 4 (actualizado): Buscar producto por PK, ahora usando fn_PrecioConImpuesto
IF OBJECT_ID('sp_BuscarProducto', 'P') IS NOT NULL
    DROP PROCEDURE sp_BuscarProducto;
GO
CREATE PROCEDURE sp_BuscarProducto
    @id_producto NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Producto WHERE id_producto = @id_producto)
    BEGIN
        RAISERROR('No existe un producto con ese id_producto.', 16, 1);
        RETURN;
    END

    SELECT *,
           dbo.fn_PrecioConImpuesto(precio) AS precio_con_impuesto
    FROM Producto
    WHERE id_producto = @id_producto;
END
GO

EXEC sp_BuscarProducto @id_producto = 'PR3';
GO


-- SP 7 (actualizado): Reporte de stock bajo, ahora usando fn_ValorInventario
IF OBJECT_ID('sp_ProductosStockBajoPorProveedor', 'P') IS NOT NULL
    DROP PROCEDURE sp_ProductosStockBajoPorProveedor;
GO
CREATE PROCEDURE sp_ProductosStockBajoPorProveedor
    @stock_minimo INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        p.id_producto,
        p.nombre_producto,
        p.stock,
        c.nombre_categoria,
        f.nombre_franquicia,
        pr.nombre_proveedor,
        pr.correo AS correo_proveedor,
        dbo.fn_ValorInventario(p.id_producto) AS valor_inventario
    FROM Producto p
    JOIN Categoria c   ON p.id_categoria = c.id_categoria
    JOIN Proveedor pr  ON p.id_proveedor = pr.id_proveedor
    LEFT JOIN Franquicia f ON p.id_franquicia = f.id_franquicia
    WHERE p.stock <= @stock_minimo
    ORDER BY p.stock ASC;
END
GO

EXEC sp_ProductosStockBajoPorProveedor @stock_minimo = 25;
GO


------------triggers ------------------

--tabla para auditoria, triggers 

IF OBJECT_ID('Auditoria_Producto', 'U') IS NOT NULL
    DROP TABLE Auditoria_Producto;
GO
CREATE TABLE Auditoria_Producto (
    id_auditoria     INT IDENTITY(1,1) NOT NULL,
    id_producto      NVARCHAR(20)  NOT NULL,
    operacion        NVARCHAR(10)  NOT NULL,
    nombre_producto  NVARCHAR(100) NULL,
    precio_anterior  DECIMAL(10,2) NULL,
    precio_nuevo     DECIMAL(10,2) NULL,
    stock_anterior   INT NULL,
    stock_nuevo      INT NULL,
    fecha_hora       DATETIME NOT NULL CONSTRAINT DF_Auditoria_Fecha DEFAULT (GETDATE()),
    usuario          NVARCHAR(100) NOT NULL CONSTRAINT DF_Auditoria_Usuario DEFAULT (SUSER_SNAME()),

    CONSTRAINT PK_AuditoriaProducto PRIMARY KEY (id_auditoria),
    CONSTRAINT CK_Auditoria_Operacion CHECK (operacion IN ('INSERT','UPDATE','DELETE'))
);
GO

-- Tabla de auditoria para Producto
IF OBJECT_ID('Auditoria_Producto', 'U') IS NOT NULL
    DROP TABLE Auditoria_Producto;
GO
CREATE TABLE Auditoria_Producto (
    id_auditoria     INT IDENTITY(1,1) NOT NULL,
    id_producto      NVARCHAR(20)  NOT NULL,
    operacion        NVARCHAR(10)  NOT NULL,
    nombre_producto  NVARCHAR(100) NULL,
    precio_anterior  DECIMAL(10,2) NULL,
    precio_nuevo     DECIMAL(10,2) NULL,
    stock_anterior   INT NULL,
    stock_nuevo      INT NULL,
    fecha_hora       DATETIME NOT NULL CONSTRAINT DF_Auditoria_Fecha DEFAULT (GETDATE()),
    usuario          NVARCHAR(100) NOT NULL CONSTRAINT DF_Auditoria_Usuario DEFAULT (USER_NAME()),

    CONSTRAINT PK_AuditoriaProducto PRIMARY KEY (id_auditoria),
    CONSTRAINT CK_Auditoria_Operacion CHECK (operacion IN ('INSERT','UPDATE','DELETE'))
);
GO


-- Trigger 1: AFTER INSERT
IF OBJECT_ID('trg_Producto_Insert_Auditoria', 'TR') IS NOT NULL
    DROP TRIGGER trg_Producto_Insert_Auditoria;
GO
CREATE TRIGGER trg_Producto_Insert_Auditoria
ON Producto
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Auditoria_Producto (id_producto, operacion, nombre_producto, precio_nuevo, stock_nuevo)
    SELECT id_producto, 'INSERT', nombre_producto, precio, stock
    FROM inserted;
END
GO

-- Prueba trigger INSERT: insertar y revisar auditoria
EXEC sp_InsertarProducto
    @id_producto = 'PR20', @nombre_producto = 'Llavero de prueba',
    @id_categoria = 'CAT3', @id_franquicia = NULL,
    @precio = 9.00, @stock = 15, @id_proveedor = 'EM1';

SELECT * FROM Auditoria_Producto WHERE id_producto = 'PR20';
GO



-- Trigger 2: AFTER UPDATE
IF OBJECT_ID('trg_Producto_Update_Auditoria', 'TR') IS NOT NULL
    DROP TRIGGER trg_Producto_Update_Auditoria;
GO
CREATE TRIGGER trg_Producto_Update_Auditoria
ON Producto
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Auditoria_Producto (id_producto, operacion, nombre_producto, precio_anterior, precio_nuevo, stock_anterior, stock_nuevo)
    SELECT
        i.id_producto,
        'UPDATE',
        i.nombre_producto,
        d.precio,
        i.precio,
        d.stock,
        i.stock
    FROM inserted i
    JOIN deleted d ON i.id_producto = d.id_producto;
END
GO

-- Prueba trigger UPDATE: actualizar precio y revisar auditoria
EXEC sp_ActualizarProducto @id_producto = 'PR20', @precio = 11.00;

SELECT * FROM Auditoria_Producto WHERE id_producto = 'PR20' ORDER BY id_auditoria;
GO

-- Trigger 3: INSTEAD OF DELETE
IF OBJECT_ID('trg_Producto_Delete_Auditoria', 'TR') IS NOT NULL
    DROP TRIGGER trg_Producto_Delete_Auditoria;
GO
CREATE TRIGGER trg_Producto_Delete_Auditoria
ON Producto
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM deleted d
        WHERE EXISTS (SELECT 1 FROM Detalle_Orden o WHERE o.id_producto = d.id_producto)
           OR EXISTS (SELECT 1 FROM Inventario_Movimientos m WHERE m.id_producto = d.id_producto)
    )
    BEGIN
        RAISERROR('No se puede eliminar: uno o mas productos tienen ordenes o movimientos de inventario asociados.', 16, 1);
        RETURN;
    END

    INSERT INTO Auditoria_Producto (id_producto, operacion, nombre_producto, precio_anterior, stock_anterior)
    SELECT id_producto, 'DELETE', nombre_producto, precio, stock
    FROM deleted;

    DELETE FROM Producto WHERE id_producto IN (SELECT id_producto FROM deleted);
END
GO

-- Prueba trigger DELETE (INSTEAD OF): producto sin dependencias, se elimina y se loguea
DELETE FROM Producto WHERE id_producto = 'PR20';

SELECT * FROM Producto WHERE id_producto = 'PR20';       -- debe salir vacio
SELECT * FROM Auditoria_Producto WHERE id_producto = 'PR20' ORDER BY id_auditoria;  -- debe tener 3 filas: INSERT, UPDATE, DELETE
GO

-- Prueba trigger DELETE (INSTEAD OF): producto CON dependencias, debe bloquearse
DELETE FROM Producto WHERE id_producto = 'PR1';
SELECT * FROM Producto WHERE id_producto = 'PR1'; -- debe seguir existiendo
GO


