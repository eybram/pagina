---------------------- PROCS ALMACENADOS
-- INSERTAR EMPLEADO

IF OBJECT_ID('sp_InsertarEmpleado', 'P') IS NOT NULL
    DROP PROCEDURE sp_InsertarEmpleado;
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
    INSERT INTO Empleado
    VALUES (@id_empleado,@nombre,@apellido,@cargo,@correo,@salario);
END
GO

-- ACTUALIZA EMPLEADO

IF OBJECT_ID('sp_ActualizarEmpleado', 'P') IS NOT NULL
    DROP PROCEDURE sp_ActualizarEmpleado;
GO

CREATE PROCEDURE sp_ActualizarEmpleado
    @id_empleado NVARCHAR(20),
    @nombre NVARCHAR(50),
    @apellido NVARCHAR(50),
    @cargo NVARCHAR(50),
    @correo NVARCHAR(100),
    @salario DECIMAL(10,2)
AS
BEGIN
    UPDATE Empleado
    SET nombre=@nombre,
        apellido=@apellido,
        cargo=@cargo,
        correo=@correo,
        salario=@salario
    WHERE id_empleado=@id_empleado;
END
GO

-- ELIMINAR EMPLEADO

IF OBJECT_ID('sp_EliminarEmpleado', 'P') IS NOT NULL
    DROP PROCEDURE sp_EliminarEmpleado;
GO

CREATE PROCEDURE sp_EliminarEmpleado
    @id_empleado NVARCHAR(20)
AS
BEGIN
    DELETE FROM Empleado
    WHERE id_empleado=@id_empleado;
END
GO

-- BUSCA EMPLEADO POR ID

IF OBJECT_ID('sp_BuscarEmpleado', 'P') IS NOT NULL
    DROP PROCEDURE sp_BuscarEmpleado;
GO

CREATE PROCEDURE sp_BuscarEmpleado
    @id_empleado NVARCHAR(20)
AS
BEGIN
    SELECT *
    FROM Empleado
    WHERE id_empleado=@id_empleado;
END
GO

-- MOSTRAR TODOS LOS EMPLEADOS

IF OBJECT_ID('sp_ListarEmpleados', 'P') IS NOT NULL
    DROP PROCEDURE sp_ListarEmpleados;
GO

CREATE PROCEDURE sp_ListarEmpleados
AS
BEGIN
    SELECT *
    FROM Empleado
    ORDER BY apellido,nombre;
END
GO

-- BUSCA EMPLEADO POR CARGO

IF OBJECT_ID('sp_EmpleadoPorCargo', 'P') IS NOT NULL
    DROP PROCEDURE sp_EmpleadoPorCargo;
GO

CREATE PROCEDURE sp_EmpleadoPorCargo
    @cargo NVARCHAR(50)
AS
BEGIN
    SELECT *
    FROM Empleado
    WHERE cargo=@cargo;
END
GO

-- SALARIO EMPLEADO MAYOR QUE

IF OBJECT_ID('sp_EmpleadoPorCargo', 'P') IS NOT NULL
    DROP PROCEDURE sp_EmpleadoPorCargo;
GO

CREATE PROCEDURE sp_EmpleadoPorCargo
    @cargo NVARCHAR(50)
AS
BEGIN
    SELECT *
    FROM Empleado
    WHERE cargo=@cargo;
END
GO

---------------------- VISTAS
-- INFO GENERAL EMPLEADOS

IF OBJECT_ID('vw_Empleados', 'V') IS NOT NULL
    DROP VIEW vw_Empleados;
GO

CREATE VIEW vw_Empleados
AS
SELECT
    id_empleado,
    nombre + ' ' + apellido AS NombreCompleto,
    cargo,
    correo,
    salario
FROM Empleado;
GO

-- EMPLEADOS ORDENES

IF OBJECT_ID('vw_EmpleadoOrdenes', 'V') IS NOT NULL
    DROP VIEW vw_EmpleadoOrdenes;
GO

CREATE VIEW vw_EmpleadoOrdenes
AS
SELECT
    e.id_empleado,
    e.nombre,
    e.apellido,
    e.cargo,
    COUNT(o.id_orden) AS TotalOrdenes
FROM Empleado e
LEFT JOIN Orden o
ON e.id_empleado=o.id_empleado
GROUP BY
e.id_empleado,
e.nombre,
e.apellido,
e.cargo;
GO

---------------------- TRIGGER
-- NO SALARIO CERO

IF OBJECT_ID('tr_ValidarSalarioEmpleado','TR') IS NOT NULL
    DROP TRIGGER tr_ValidarSalarioEmpleado;
GO

CREATE TRIGGER tr_ValidarSalarioEmpleado
ON Empleado
INSTEAD OF INSERT
AS
BEGIN

    IF EXISTS(
        SELECT *
        FROM inserted
        WHERE salario<=0
    )
    BEGIN
        RAISERROR('El salario debe ser mayor que cero.',16,1);
        RETURN;
    END

    INSERT INTO Empleado
    SELECT *
    FROM inserted;

END
GO