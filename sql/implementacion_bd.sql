-- =========================================================
-- CONSOLIDATED SQL SCRIPT - BROKEN POCKET
-- Procedimientos, Funciones, Vistas y Triggers
-- =========================================================

USE [Broken Pocket]
GO

-- =========================================================
-- TABLAS DE AUDITORÍA
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
-- FUNCIONES DEFINIDAS POR USUARIO
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
-- PROCEDIMIENTOS - PRODUCTO
-- =========================================================

IF OBJECT_ID('sp_InsertarProducto', 'P') IS NOT NULL DROP PROCEDURE sp_InsertarProducto;
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

IF OBJECT_ID('sp_ActualizarProducto', 'P') IS NOT NULL DROP PROCEDURE sp_ActualizarProducto;
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
    SET
        nombre_producto = ISNULL(@nombre_producto, nombre_producto),
        id_categoria    = ISNULL(@id_categoria, id_categoria),
        id_franquicia   = ISNULL(@id_franquicia, id_franquicia),
        precio          = ISNULL(@precio, precio),
        stock           = ISNULL(@stock, stock),
        id_proveedor    = ISNULL(@id_proveedor, id_proveedor)
    WHERE id_producto = @id_producto;
END
GO

IF OBJECT_ID('sp_ObtenerProducto', 'P') IS NOT NULL DROP PROCEDURE sp_ObtenerProducto;
GO
CREATE PROCEDURE sp_ObtenerProducto @id_producto NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM Producto WHERE id_producto = @id_producto;
END
GO

IF OBJECT_ID('sp_ListarProductos', 'P') IS NOT NULL DROP PROCEDURE sp_ListarProductos;
GO
CREATE PROCEDURE sp_ListarProductos
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM Producto ORDER BY nombre_producto;
END
GO

-- =========================================================
-- PROCEDIMIENTOS - CLIENTE
-- =========================================================

IF OBJECT_ID('sp_InsertarCliente', 'P') IS NOT NULL DROP PROCEDURE sp_InsertarCliente;
GO
CREATE PROCEDURE sp_InsertarCliente
    @id_cliente     NVARCHAR(20),
    @nombre         NVARCHAR(50),
    @apellido       NVARCHAR(50),
    @cedula         NVARCHAR(20),
    @correo         NVARCHAR(100),
    @telefono       NVARCHAR(20) = NULL,
    @provincia      NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Cliente WHERE id_cliente = @id_cliente)
        BEGIN
            RAISERROR('Ya existe un cliente con ese id.', 16, 1);
            RETURN;
        END

        INSERT INTO Cliente (id_cliente, nombre, apellido, cedula, correo, telefono, provincia)
        VALUES (@id_cliente, @nombre, @apellido, @cedula, @correo, @telefono, @provincia);
    END TRY
    BEGIN CATCH
        RAISERROR('Error al insertar cliente.', 16, 1);
    END CATCH
END
GO

IF OBJECT_ID('sp_ActualizarCliente', 'P') IS NOT NULL DROP PROCEDURE sp_ActualizarCliente;
GO
CREATE PROCEDURE sp_ActualizarCliente
    @id_cliente     NVARCHAR(20),
    @nombre         NVARCHAR(50) = NULL,
    @apellido       NVARCHAR(50) = NULL,
    @cedula         NVARCHAR(20) = NULL,
    @correo         NVARCHAR(100) = NULL,
    @telefono       NVARCHAR(20) = NULL,
    @provincia      NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Cliente WHERE id_cliente = @id_cliente)
        BEGIN
            RAISERROR('No existe un cliente con ese id.', 16, 1);
            RETURN;
        END

        UPDATE Cliente
        SET nombre = ISNULL(@nombre, nombre),
            apellido = ISNULL(@apellido, apellido),
            cedula = ISNULL(@cedula, cedula),
            correo = ISNULL(@correo, correo),
            telefono = ISNULL(@telefono, telefono),
            provincia = ISNULL(@provincia, provincia)
        WHERE id_cliente = @id_cliente;
    END TRY
    BEGIN CATCH
        RAISERROR('Error al actualizar cliente.', 16, 1);
    END CATCH
END
GO

IF OBJECT_ID('sp_EliminarCliente', 'P') IS NOT NULL DROP PROCEDURE sp_EliminarCliente;
GO
CREATE PROCEDURE sp_EliminarCliente @id_cliente NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Cliente WHERE id_cliente = @id_cliente)
        BEGIN
            RAISERROR('No existe un cliente con ese id.', 16, 1);
            RETURN;
        END
        DELETE FROM Cliente WHERE id_cliente = @id_cliente;
    END TRY
    BEGIN CATCH
        RAISERROR('Error al eliminar cliente.', 16, 1);
    END CATCH
END
GO

IF OBJECT_ID('sp_ObtenerCliente', 'P') IS NOT NULL DROP PROCEDURE sp_ObtenerCliente;
GO
CREATE PROCEDURE sp_ObtenerCliente @id_cliente NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM Cliente WHERE id_cliente = @id_cliente;
END
GO

IF OBJECT_ID('sp_ListarClientes', 'P') IS NOT NULL DROP PROCEDURE sp_ListarClientes;
GO
CREATE PROCEDURE sp_ListarClientes
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM Cliente ORDER BY apellido, nombre;
END
GO

-- =========================================================
-- PROCEDIMIENTOS - PROVEEDOR
-- =========================================================

IF OBJECT_ID('sp_InsertarProveedor', 'P') IS NOT NULL DROP PROCEDURE sp_InsertarProveedor;
GO
CREATE PROCEDURE sp_InsertarProveedor
    @id_proveedor NVARCHAR(20), 
    @nombre_proveedor NVARCHAR(100), 
    @contacto NVARCHAR(50) = NULL,
    @telefono NVARCHAR(30) = NULL,
    @pais NVARCHAR(50) = NULL,
    @correo NVARCHAR(100)
AS
BEGIN
    INSERT INTO Proveedor (id_proveedor, nombre_proveedor, contacto, telefono, pais, correo)
    VALUES (@id_proveedor, @nombre_proveedor, @contacto, @telefono, ISNULL(@pais, 'Panamá'), @correo);
END
GO

IF OBJECT_ID('sp_ActualizarProveedor', 'P') IS NOT NULL DROP PROCEDURE sp_ActualizarProveedor;
GO
CREATE PROCEDURE sp_ActualizarProveedor
    @id_proveedor NVARCHAR(20), 
    @nombre_proveedor NVARCHAR(100) = NULL,
    @contacto NVARCHAR(50) = NULL,
    @telefono NVARCHAR(30) = NULL,
    @pais NVARCHAR(50) = NULL,
    @correo NVARCHAR(100) = NULL
AS
BEGIN
    UPDATE Proveedor
    SET nombre_proveedor = ISNULL(@nombre_proveedor, nombre_proveedor),
        contacto = ISNULL(@contacto, contacto),
        telefono = ISNULL(@telefono, telefono),
        pais = ISNULL(@pais, pais),
        correo = ISNULL(@correo, correo)
    WHERE id_proveedor = @id_proveedor;
END
GO

IF OBJECT_ID('sp_EliminarProveedor', 'P') IS NOT NULL DROP PROCEDURE sp_EliminarProveedor;
GO
CREATE PROCEDURE sp_EliminarProveedor @id_proveedor NVARCHAR(20)
AS
BEGIN
    DELETE FROM Proveedor WHERE id_proveedor = @id_proveedor;
END
GO

IF OBJECT_ID('sp_ObtenerProveedor', 'P') IS NOT NULL DROP PROCEDURE sp_ObtenerProveedor;
GO
CREATE PROCEDURE sp_ObtenerProveedor @id_proveedor NVARCHAR(20)
AS
BEGIN
    SELECT * FROM Proveedor WHERE id_proveedor = @id_proveedor;
END
GO

IF OBJECT_ID('sp_ListarProveedores', 'P') IS NOT NULL DROP PROCEDURE sp_ListarProveedores;
GO
CREATE PROCEDURE sp_ListarProveedores
AS
BEGIN
    SELECT * FROM Proveedor ORDER BY nombre_proveedor;
END
GO

IF OBJECT_ID('sp_ProductosPorProveedor', 'P') IS NOT NULL DROP PROCEDURE sp_ProductosPorProveedor;
GO
CREATE PROCEDURE sp_ProductosPorProveedor @id_proveedor NVARCHAR(20)
AS
BEGIN
    SELECT p.nombre_producto, c.nombre_categoria, p.precio, p.stock
    FROM Producto p
    JOIN Categoria c ON c.id_categoria = p.id_categoria
    WHERE p.id_proveedor = @id_proveedor;
END
GO

-- =========================================================
-- PROCEDIMIENTOS - CATEGORIA
-- =========================================================

IF OBJECT_ID('sp_InsertarCategoria', 'P') IS NOT NULL DROP PROCEDURE sp_InsertarCategoria;
GO
CREATE PROCEDURE sp_InsertarCategoria
    @id NVARCHAR(20),
    @nombre NVARCHAR(50),
    @descripcion NVARCHAR(150) = NULL
AS
BEGIN
    INSERT INTO Categoria VALUES(@id,@nombre,@descripcion);
END
GO

IF OBJECT_ID('sp_ActualizarCategoria', 'P') IS NOT NULL DROP PROCEDURE sp_ActualizarCategoria;
GO
CREATE PROCEDURE sp_ActualizarCategoria
    @id NVARCHAR(20),
    @nombre NVARCHAR(50) = NULL,
    @descripcion NVARCHAR(150) = NULL
AS
BEGIN
    UPDATE Categoria
    SET nombre_categoria = ISNULL(@nombre, nombre_categoria),
        descripcion = ISNULL(@descripcion, descripcion)
    WHERE id_categoria=@id;
END
GO

IF OBJECT_ID('sp_EliminarCategoria', 'P') IS NOT NULL DROP PROCEDURE sp_EliminarCategoria;
GO
CREATE PROCEDURE sp_EliminarCategoria @id NVARCHAR(20)
AS
BEGIN
    DELETE FROM Categoria WHERE id_categoria=@id;
END
GO

IF OBJECT_ID('sp_ObtenerCategoria', 'P') IS NOT NULL DROP PROCEDURE sp_ObtenerCategoria;
GO
CREATE PROCEDURE sp_ObtenerCategoria @id NVARCHAR(20)
AS
BEGIN
    SELECT * FROM Categoria WHERE id_categoria=@id;
END
GO

IF OBJECT_ID('sp_ListarCategorias', 'P') IS NOT NULL DROP PROCEDURE sp_ListarCategorias;
GO
CREATE PROCEDURE sp_ListarCategorias
AS
BEGIN
    SELECT * FROM Categoria ORDER BY nombre_categoria;
END
GO

-- =========================================================
-- PROCEDIMIENTOS - FRANQUICIA
-- =========================================================

IF OBJECT_ID('sp_InsertarFranquicia', 'P') IS NOT NULL DROP PROCEDURE sp_InsertarFranquicia;
GO
CREATE PROCEDURE sp_InsertarFranquicia
    @id NVARCHAR(20),
    @nombre NVARCHAR(50),
    @matriz NVARCHAR(50) = NULL
AS
BEGIN
    INSERT INTO Franquicia VALUES(@id,@nombre,@matriz);
END
GO

IF OBJECT_ID('sp_ActualizarFranquicia', 'P') IS NOT NULL DROP PROCEDURE sp_ActualizarFranquicia;
GO
CREATE PROCEDURE sp_ActualizarFranquicia
    @id NVARCHAR(20),
    @nombre NVARCHAR(50) = NULL,
    @matriz NVARCHAR(50) = NULL
AS
BEGIN
    UPDATE Franquicia
    SET nombre_franquicia = ISNULL(@nombre, nombre_franquicia),
        casa_matriz = ISNULL(@matriz, casa_matriz)
    WHERE id_franquicia=@id;
END
GO

IF OBJECT_ID('sp_EliminarFranquicia', 'P') IS NOT NULL DROP PROCEDURE sp_EliminarFranquicia;
GO
CREATE PROCEDURE sp_EliminarFranquicia @id NVARCHAR(20)
AS
BEGIN
    DELETE FROM Franquicia WHERE id_franquicia=@id;
END
GO

IF OBJECT_ID('sp_ObtenerFranquicia', 'P') IS NOT NULL DROP PROCEDURE sp_ObtenerFranquicia;
GO
CREATE PROCEDURE sp_ObtenerFranquicia @id NVARCHAR(20)
AS
BEGIN
    SELECT * FROM Franquicia WHERE id_franquicia=@id;
END
GO

IF OBJECT_ID('sp_ListarFranquicias', 'P') IS NOT NULL DROP PROCEDURE sp_ListarFranquicias;
GO
CREATE PROCEDURE sp_ListarFranquicias
AS
BEGIN
    SELECT * FROM Franquicia ORDER BY nombre_franquicia;
END
GO

-- =========================================================
-- PROCEDIMIENTOS - EMPLEADO
-- =========================================================

IF OBJECT_ID('sp_InsertarEmpleado', 'P') IS NOT NULL DROP PROCEDURE sp_InsertarEmpleado;
GO
CREATE PROCEDURE sp_InsertarEmpleado
    @id_empleado NVARCHAR(20),
    @nombre NVARCHAR(50),
    @apellido NVARCHAR(50),
    @cargo NVARCHAR(50),
    @correo NVARCHAR(100),
    @salario DECIMAL(10,2)
AS
BEGIN
    INSERT INTO Empleado VALUES (@id_empleado,@nombre,@apellido,@cargo,@correo,@salario);
END
GO

IF OBJECT_ID('sp_ActualizarEmpleado', 'P') IS NOT NULL DROP PROCEDURE sp_ActualizarEmpleado;
GO
CREATE PROCEDURE sp_ActualizarEmpleado
    @id_empleado NVARCHAR(20),
    @nombre NVARCHAR(50) = NULL,
    @apellido NVARCHAR(50) = NULL,
    @cargo NVARCHAR(50) = NULL,
    @correo NVARCHAR(100) = NULL,
    @salario DECIMAL(10,2) = NULL
AS
BEGIN
    UPDATE Empleado
    SET nombre = ISNULL(@nombre, nombre),
        apellido = ISNULL(@apellido, apellido),
        cargo = ISNULL(@cargo, cargo),
        correo = ISNULL(@correo, correo),
        salario = ISNULL(@salario, salario)
    WHERE id_empleado=@id_empleado;
END
GO

IF OBJECT_ID('sp_EliminarEmpleado', 'P') IS NOT NULL DROP PROCEDURE sp_EliminarEmpleado;
GO
CREATE PROCEDURE sp_EliminarEmpleado @id_empleado NVARCHAR(20)
AS
BEGIN
    DELETE FROM Empleado WHERE id_empleado=@id_empleado;
END
GO

IF OBJECT_ID('sp_ObtenerEmpleado', 'P') IS NOT NULL DROP PROCEDURE sp_ObtenerEmpleado;
GO
CREATE PROCEDURE sp_ObtenerEmpleado @id_empleado NVARCHAR(20)
AS
BEGIN
    SELECT * FROM Empleado WHERE id_empleado=@id_empleado;
END
GO

IF OBJECT_ID('sp_ListarEmpleados', 'P') IS NOT NULL DROP PROCEDURE sp_ListarEmpleados;
GO
CREATE PROCEDURE sp_ListarEmpleados
AS
BEGIN
    SELECT * FROM Empleado ORDER BY apellido,nombre;
END
GO

IF OBJECT_ID('sp_EmpleadoPorCargo', 'P') IS NOT NULL DROP PROCEDURE sp_EmpleadoPorCargo;
GO
CREATE PROCEDURE sp_EmpleadoPorCargo @cargo NVARCHAR(50)
AS
BEGIN
    SELECT * FROM Empleado WHERE cargo=@cargo;
END
GO

-- =========================================================
-- PROCEDIMIENTOS - ORDEN
-- =========================================================

IF OBJECT_ID('sp_InsertarOrden', 'P') IS NOT NULL DROP PROCEDURE sp_InsertarOrden;
GO
CREATE PROCEDURE sp_InsertarOrden
    @id_orden NVARCHAR(20), 
    @id_cliente NVARCHAR(20), 
    @id_empleado NVARCHAR(20),
    @fecha_orden DATE = NULL, 
    @total DECIMAL(10,2), 
    @metodo_pago NVARCHAR(20)
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

IF OBJECT_ID('sp_ActualizarOrden', 'P') IS NOT NULL DROP PROCEDURE sp_ActualizarOrden;
GO
CREATE PROCEDURE sp_ActualizarOrden
    @id_orden NVARCHAR(20), 
    @total DECIMAL(10,2) = NULL, 
    @metodo_pago NVARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Orden WHERE id_orden = @id_orden)
    BEGIN
        RAISERROR('La orden no existe.', 16, 1);
        RETURN;
    END
    UPDATE Orden
    SET total = ISNULL(@total, total), 
        metodo_pago = ISNULL(@metodo_pago, metodo_pago)
    WHERE id_orden = @id_orden;
END
GO

IF OBJECT_ID('sp_EliminarOrden', 'P') IS NOT NULL DROP PROCEDURE sp_EliminarOrden;
GO
CREATE PROCEDURE sp_EliminarOrden @id_orden NVARCHAR(20)
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

IF OBJECT_ID('sp_ObtenerOrden', 'P') IS NOT NULL DROP PROCEDURE sp_ObtenerOrden;
GO
CREATE PROCEDURE sp_ObtenerOrden @id_orden NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM Orden WHERE id_orden = @id_orden;
END
GO

IF OBJECT_ID('sp_ListarOrdenes', 'P') IS NOT NULL DROP PROCEDURE sp_ListarOrdenes;
GO
CREATE PROCEDURE sp_ListarOrdenes
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM Orden ORDER BY fecha_orden DESC;
END
GO

-- =========================================================
-- PROCEDIMIENTOS - DETALLE_ORDEN
-- =========================================================

IF OBJECT_ID('sp_InsertarDetalleOrden', 'P') IS NOT NULL DROP PROCEDURE sp_InsertarDetalleOrden;
GO
CREATE PROCEDURE sp_InsertarDetalleOrden
    @id_orden NVARCHAR(20), 
    @id_producto NVARCHAR(20), 
    @cantidad INT, 
    @precio_unitario DECIMAL(10,2)
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
        RAISERROR('Ese producto ya está en la orden.', 16, 1);
        RETURN;
    END
    INSERT INTO Detalle_Orden (id_orden, id_producto, cantidad, precio_unitario, subtotal)
    VALUES (@id_orden, @id_producto, @cantidad, @precio_unitario, @cantidad * @precio_unitario);
END
GO

IF OBJECT_ID('sp_ActualizarDetalleOrden', 'P') IS NOT NULL DROP PROCEDURE sp_ActualizarDetalleOrden;
GO
CREATE PROCEDURE sp_ActualizarDetalleOrden
    @id_orden NVARCHAR(20), 
    @id_producto NVARCHAR(20), 
    @cantidad INT = NULL, 
    @precio_unitario DECIMAL(10,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Detalle_Orden WHERE id_orden = @id_orden AND id_producto = @id_producto)
    BEGIN
        RAISERROR('El detalle no existe.', 16, 1);
        RETURN;
    END
    DECLARE @cant INT = ISNULL(@cantidad, (SELECT cantidad FROM Detalle_Orden WHERE id_orden = @id_orden AND id_producto = @id_producto));
    DECLARE @precio DECIMAL(10,2) = ISNULL(@precio_unitario, (SELECT precio_unitario FROM Detalle_Orden WHERE id_orden = @id_orden AND id_producto = @id_producto));
    
    UPDATE Detalle_Orden
    SET cantidad = @cant, 
        precio_unitario = @precio, 
        subtotal = @cant * @precio
    WHERE id_orden = @id_orden AND id_producto = @id_producto;
END
GO

IF OBJECT_ID('sp_EliminarDetalleOrden', 'P') IS NOT NULL DROP PROCEDURE sp_EliminarDetalleOrden;
GO
CREATE PROCEDURE sp_EliminarDetalleOrden 
    @id_orden NVARCHAR(20), 
    @id_producto NVARCHAR(20)
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

IF OBJECT_ID('sp_ObtenerDetalleOrden', 'P') IS NOT NULL DROP PROCEDURE sp_ObtenerDetalleOrden;
GO
CREATE PROCEDURE sp_ObtenerDetalleOrden 
    @id_orden NVARCHAR(20), 
    @id_producto NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM Detalle_Orden WHERE id_orden = @id_orden AND id_producto = @id_producto;
END
GO

IF OBJECT_ID('sp_ListarDetallesOrden', 'P') IS NOT NULL DROP PROCEDURE sp_ListarDetallesOrden;
GO
CREATE PROCEDURE sp_ListarDetallesOrden
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM Detalle_Orden;
END
GO

-- =========================================================
-- PROCEDIMIENTOS - INVENTARIO_MOVIMIENTOS
-- =========================================================

IF OBJECT_ID('sp_InsertarMovimiento', 'P') IS NOT NULL DROP PROCEDURE sp_InsertarMovimiento;
GO
CREATE PROCEDURE sp_InsertarMovimiento
    @id_mov NVARCHAR(20), 
    @id_producto NVARCHAR(20), 
    @tipo NVARCHAR(20), 
    @cantidad INT, 
    @desc NVARCHAR(200) = NULL
AS
BEGIN
    INSERT INTO Inventario_Movimientos (id_mov, id_producto, tipo_movimiento, cantidad, fecha_movimiento, descripcion)
    VALUES (@id_mov, @id_producto, @tipo, @cantidad, GETDATE(), @desc)
END
GO

IF OBJECT_ID('sp_ActualizarMovimiento', 'P') IS NOT NULL DROP PROCEDURE sp_ActualizarMovimiento;
GO
CREATE PROCEDURE sp_ActualizarMovimiento
    @id_mov NVARCHAR(20), 
    @cantidad INT = NULL, 
    @desc NVARCHAR(200) = NULL
AS
BEGIN
    UPDATE Inventario_Movimientos 
    SET cantidad = ISNULL(@cantidad, cantidad), 
        descripcion = ISNULL(@desc, descripcion) 
    WHERE id_mov = @id_mov
END
GO

IF OBJECT_ID('sp_EliminarMovimiento', 'P') IS NOT NULL DROP PROCEDURE sp_EliminarMovimiento;
GO
CREATE PROCEDURE sp_EliminarMovimiento @id_mov NVARCHAR(20)
AS
BEGIN
    DELETE FROM Inventario_Movimientos WHERE id_mov = @id_mov
END
GO

IF OBJECT_ID('sp_ObtenerMovimiento', 'P') IS NOT NULL DROP PROCEDURE sp_ObtenerMovimiento;
GO
CREATE PROCEDURE sp_ObtenerMovimiento @id_mov NVARCHAR(20)
AS
BEGIN
    SELECT * FROM Inventario_Movimientos WHERE id_mov = @id_mov
END
GO

IF OBJECT_ID('sp_ListarMovimientos', 'P') IS NOT NULL DROP PROCEDURE sp_ListarMovimientos;
GO
CREATE PROCEDURE sp_ListarMovimientos
AS
BEGIN
    SELECT * FROM Inventario_Movimientos ORDER BY fecha_movimiento DESC
END
GO

-- =========================================================
-- VISTAS
-- =========================================================

IF OBJECT_ID('vw_Categorias', 'V') IS NOT NULL DROP VIEW vw_Categorias;
GO
CREATE VIEW vw_Categorias AS
SELECT id_categoria, nombre_categoria, descripcion
FROM Categoria;
GO

IF OBJECT_ID('vw_CategoriasProductos', 'V') IS NOT NULL DROP VIEW vw_CategoriasProductos;
GO
CREATE VIEW vw_CategoriasProductos AS
SELECT C.nombre_categoria, COUNT(P.id_producto) AS CantidadProductos
FROM Categoria C LEFT JOIN Producto P ON C.id_categoria = P.id_categoria
GROUP BY C.nombre_categoria;
GO

IF OBJECT_ID('vw_Franquicias', 'V') IS NOT NULL DROP VIEW vw_Franquicias;
GO
CREATE VIEW vw_Franquicias AS
SELECT id_franquicia, nombre_franquicia, casa_matriz FROM Franquicia;
GO

IF OBJECT_ID('vw_FranquiciasProductos', 'V') IS NOT NULL DROP VIEW vw_FranquiciasProductos;
GO
CREATE VIEW vw_FranquiciasProductos AS
SELECT F.nombre_franquicia, COUNT(P.id_producto) AS Productos
FROM Franquicia F LEFT JOIN Producto P ON F.id_franquicia = P.id_franquicia
GROUP BY F.nombre_franquicia;
GO

IF OBJECT_ID('vw_Empleados', 'V') IS NOT NULL DROP VIEW vw_Empleados;
GO
CREATE VIEW vw_Empleados AS
SELECT id_empleado, nombre + ' ' + apellido AS NombreCompleto, cargo, correo, salario FROM Empleado;
GO

IF OBJECT_ID('vw_EmpleadoOrdenes', 'V') IS NOT NULL DROP VIEW vw_EmpleadoOrdenes;
GO
CREATE VIEW vw_EmpleadoOrdenes AS
SELECT e.id_empleado, e.nombre, e.apellido, e.cargo, COUNT(o.id_orden) AS TotalOrdenes
FROM Empleado e LEFT JOIN Orden o ON e.id_empleado=o.id_empleado
GROUP BY e.id_empleado, e.nombre, e.apellido, e.cargo;
GO

IF OBJECT_ID('vw_OrdenResumen', 'V') IS NOT NULL DROP VIEW vw_OrdenResumen;
GO
CREATE VIEW vw_OrdenResumen AS
SELECT o.id_orden, c.nombre + ' ' + c.apellido AS Cliente, e.nombre + ' ' + e.apellido AS Empleado,
       o.fecha_orden, o.metodo_pago, o.total
FROM Orden o
INNER JOIN Cliente c ON o.id_cliente = c.id_cliente
INNER JOIN Empleado e ON o.id_empleado = e.id_empleado;
GO

IF OBJECT_ID('vw_OrdenVentasAltas', 'V') IS NOT NULL DROP VIEW vw_OrdenVentasAltas;
GO
CREATE VIEW vw_OrdenVentasAltas AS
SELECT o.id_orden, c.nombre + ' ' + c.apellido AS Cliente, e.cargo AS AtendidoPor,
       o.fecha_orden, o.total
FROM Orden o
INNER JOIN Cliente c ON o.id_cliente = c.id_cliente
INNER JOIN Empleado e ON o.id_empleado = e.id_empleado
WHERE o.total > 30;
GO

IF OBJECT_ID('vw_DetalleOrdenCompleto', 'V') IS NOT NULL DROP VIEW vw_DetalleOrdenCompleto;
GO
CREATE VIEW vw_DetalleOrdenCompleto AS
SELECT d.id_orden, p.nombre_producto, d.cantidad, d.precio_unitario, d.subtotal
FROM Detalle_Orden d INNER JOIN Producto p ON d.id_producto = p.id_producto;
GO

IF OBJECT_ID('vw_InvMovEntradas', 'V') IS NOT NULL DROP VIEW vw_InvMovEntradas;
GO
CREATE VIEW vw_InvMovEntradas AS
SELECT * FROM Inventario_Movimientos WHERE tipo_movimiento = 'Entrada';
GO

IF OBJECT_ID('vw_InvMovSalidas', 'V') IS NOT NULL DROP VIEW vw_InvMovSalidas;
GO
CREATE VIEW vw_InvMovSalidas AS
SELECT * FROM Inventario_Movimientos WHERE tipo_movimiento = 'Salida';
GO

-- =========================================================
-- TRIGGERS
-- =========================================================

IF OBJECT_ID('tr_ValidarSalarioEmpleado','TR') IS NOT NULL DROP TRIGGER tr_ValidarSalarioEmpleado;
GO
CREATE TRIGGER tr_ValidarSalarioEmpleado
ON Empleado
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS(SELECT * FROM inserted WHERE salario<=0)
    BEGIN
        RAISERROR('El salario debe ser mayor que cero.',16,1);
        RETURN;
    END
    INSERT INTO Empleado SELECT * FROM inserted;
END
GO

IF OBJECT_ID('TR_DetalleOrden_ActualizarTotalOrden', 'TR') IS NOT NULL DROP TRIGGER TR_DetalleOrden_ActualizarTotalOrden;
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

        UPDATE Orden SET total = dbo.fn_CalcularTotalOrden(@id_orden) WHERE id_orden = @id_orden;

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

IF OBJECT_ID('TR_Orden_Auditoria', 'TR') IS NOT NULL DROP TRIGGER TR_Orden_Auditoria;
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

PRINT 'Todas las funciones, procedimientos, vistas y triggers han sido creados correctamente.';
GO
