-- Crear base de datos Broken Pocket (ejecutar en master)
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'Broken Pocket')
BEGIN
    CREATE DATABASE [Broken Pocket];
END
GO
