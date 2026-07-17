
USE [Broken Pocket]
GO


  -- 1. CLIENTE

INSERT INTO Cliente (id_cliente, nombre, apellido, cedula, correo, telefono, provincia, fecha_registro) VALUES
('Pd1', 'Ana', 'Castillo', '8-945-1234', 'ana.c@gmail.com', '6789-1122', 'Panam�', '2025-01-12'),
('Pd2', 'Marcos', 'Guti�rrez', '4-567-902', 'marcos.gt@gmail.com', '6001-8877', 'Chiriqu�', '2025-02-10'),
('Pd3', 'Luis', 'Moreno', '3-1023-444', 'luism@example.com', '6999-3321', 'Veraguas', '2023-03-05'),
('Pd4', 'Sof�a', 'R�os', '2-788-331', 'sofri@gmail.com', '6123-9876', 'Panam� Oeste', '2024-03-20'),
('Pd5', 'Daniel', 'Vega', '1-332-819', 'daniel.vg@gmail.com', '6555-1234', 'Col�n', '2024-04-01'),
('Pd6', 'Karla', 'Hern�ndez', '9-122-432', 'karla.hz@gmail.com', '6990-1212', 'Herrera', '2025-04-10'),
('Pd7', 'Jorge', 'Rivas', '6-332-728', 'jrivas90@gmail.com', '6988-4411', 'Cocl�', '2024-05-02'),
('Pd8', 'Rebeca', 'Lasso', '8-112-567', 'reb.lasso@gmail.com', '6221-4789', 'Panam�', '2024-05-22');
GO


  -- 2. PROVEEDOR
 
INSERT INTO Proveedor (id_proveedor, nombre_proveedor, contacto, telefono, pais, correo) VALUES
('EM1', 'Gaming World Supply', 'Karen Smith', '+1 555-222', 'USA', 'contact@gwsupply.com'),
('EM2', 'PlayMerch LATAM', 'Ricardo Torres', '+507 6000-1122', 'Panam�', 'ventas@playmerch.com'),
('EM3', 'HaloCollectibles Inc', 'Mark Green', '+1 555-300', 'USA', 'support@halocollect.com'),
('EM4', 'Funko International', 'Jhon Atkins', '+1 555-902', 'USA', 'info@funko.com'),
('EM5', 'GeekMerch Europe', 'Johana M�ller', '+49 331-882', 'Alemania', 'jmuller@geekmerch.de');
GO


  -- 3. CATEGORIA (extra�da de los productos)

INSERT INTO Categoria (id_categoria, nombre_categoria, descripcion) VALUES
('CAT1', 'Camiseta', 'Ropa estampada con dise�os de franquicias geek'),
('CAT2', 'Figura', 'Figuras coleccionables y Funko Pop'),
('CAT3', 'Llavero', 'Llaveros coleccionables de personajes'),
('CAT4', 'Poster', 'Posters e ilustraciones decorativas');
GO


   --4. FRANQUICIA (extra�da de los productos)

INSERT INTO Franquicia (id_franquicia, nombre_franquicia, casa_matriz) VALUES
('FR1', 'Zelda', 'Nintendo'),
('FR2', 'God of War', 'Sony Santa Monica'),
('FR3', 'Pok�mon', 'Game Freak / Nintendo'),
('FR4', 'Halo', '343 Industries'),
('FR5', 'Nintendo', 'Nintendo'),
('FR6', 'Bethesda', 'Bethesda Softworks'),
('FR7', 'Minecraft', 'Mojang Studios'),
('FR8', 'Hollow Knight', 'Team Cherry');
GO


  -- 5. PRODUCTO
 
INSERT INTO Producto (id_producto, nombre_producto, id_categoria, id_franquicia, precio, stock, id_proveedor) VALUES
('PR1', 'Camiseta Zelda Master Sword', 'CAT1', 'FR1', 25.00, 50, 'EM1'),
('PR2', 'Figura Funko de Kratos', 'CAT2', 'FR2', 35.00, 30, 'EM4'),
('PR3', 'Llavero Pok�ball', 'CAT3', 'FR3', 10.00, 80, 'EM1'),
('PR4', 'Poster Halo Infinite', 'CAT4', 'FR4', 12.00, 40, 'EM3'),
('PR5', 'Figura de Mario Kart', 'CAT2', 'FR5', 28.00, 25, 'EM1'),
('PR6', 'Camiseta de Starfield', 'CAT1', 'FR6', 22.00, 35, 'EM2'),
('PR7', 'Llavero de Creeper', 'CAT3', 'FR7', 8.00, 120, 'EM5'),
('PR8', 'Figura Funko de Pikachu', 'CAT2', 'FR3', 32.00, 20, 'EM4'),
('PR9', 'Poster de God of War Ragnar�k', 'CAT4', 'FR2', 15.00, 18, 'EM5'),
('PR10', 'Camiseta de Hollow Knight', 'CAT1', 'FR8', 20.00, 60, 'EM2');
GO


   /*6. EMPLEADO
   (cargo alineado con el CHECK: Vendedor, Cajero, Bodeguero, Administrador)*/

INSERT INTO Empleado (id_empleado, nombre, apellido, cargo, correo, salario) VALUES
('EMP1', 'Pedro', 'Ruiz', 'Cajero', 'pedror@bp.com', 850.00),
('EMP2', 'Carla', 'G�mez', 'Administrador', 'carlag@bp.com', 1200.00),
('EMP3', 'Julio', 'S�enz', 'Bodeguero', 'julio.s@bp.com', 950.00),
('EMP4', 'Esther', 'Moreno', 'Vendedor', 'estherm@bp.com', 900.00),
('EMP5', 'Diana', 'L�pez', 'Vendedor', 'dianal@bp.com', 900.00);
GO


  /* 7. ORDEN
   (fechas corregidas para ser posteriores al registro del cliente,
    totales recalculados seg�n el detalle real, y empleado asignado)*/
  
INSERT INTO Orden (id_orden, id_cliente, id_empleado, fecha_orden, total, metodo_pago) VALUES
('Ord_1', 'Pd1', 'EMP1', '2025-02-01', 61.00, 'Tarjeta'),
('Ord_2', 'Pd2', 'EMP4', '2025-02-15', 35.00, 'Efectivo'),
('Ord_3', 'Pd1', 'EMP5', '2025-03-01', 60.00, 'Yappy'),
('Ord_4', 'Pd4', 'EMP1', '2025-03-18', 10.00, 'Tarjeta'),
('Ord_5', 'Pd3', 'EMP4', '2023-03-20', 32.00, 'Tarjeta'),
('Ord_6', 'Pd5', 'EMP5', '2025-04-02', 40.00, 'Yappy'),
('Ord_7', 'Pd6', 'EMP1', '2025-05-12', 32.00, 'Efectivo'),
('Ord_8', 'Pd7', 'EMP4', '2025-04-25', 28.00, 'Tarjeta'),
('Ord_9', 'Pd8', 'EMP5', '2024-06-10', 74.00, 'Tarjeta'),
('Ord_10', 'Pd5', 'EMP1', '2025-05-22', 22.00, 'Efectivo');
GO


  /* 8. DETALLE_ORDEN
   (ya no lleva id_detalle: PK compuesta id_orden + id_producto)*/
 
INSERT INTO Detalle_Orden (id_orden, id_producto, cantidad, precio_unitario, subtotal) VALUES
('Ord_1', 'PR1', 1, 25.00, 25.00),
('Ord_1', 'PR3', 2, 10.00, 20.00),
('Ord_1', 'PR7', 2, 8.00, 16.00),
('Ord_2', 'PR2', 1, 35.00, 35.00),
('Ord_3', 'PR1', 1, 25.00, 25.00),
('Ord_3', 'PR2', 1, 35.00, 35.00),
('Ord_4', 'PR3', 1, 10.00, 10.00),
('Ord_5', 'PR4', 1, 12.00, 12.00),
('Ord_5', 'PR3', 2, 10.00, 20.00),
('Ord_6', 'PR10', 2, 20.00, 40.00),
('Ord_7', 'PR7', 4, 8.00, 32.00),
('Ord_8', 'PR5', 1, 28.00, 28.00),
('Ord_9', 'PR8', 2, 32.00, 64.00),
('Ord_9', 'PR3', 1, 10.00, 10.00),
('Ord_10', 'PR6', 1, 22.00, 22.00);
GO


  /* 9. INVENTARIO_MOVIMIENTOS
   (fechas y cantidades ajustadas para cuadrar con las ventas reales
    descritas en cada movimiento de tipo SALIDA)*/

INSERT INTO Inventario_Movimientos (id_mov, id_producto, tipo_movimiento, cantidad, fecha_movimiento, descripcion) VALUES
('MOV1', 'PR1', 'Entrada', 50, '2025-01-10', 'Lote inicial'),
('MOV2', 'PR2', 'Entrada', 30, '2025-02-01', 'Reabastecimiento'),
('MOV3', 'PR3', 'Salida', 2, '2025-02-01', 'Venta Ord_1'),
('MOV4', 'PR4', 'Entrada', 40, '2024-03-12', 'Reabastecimiento'),
('MOV5', 'PR7', 'Entrada', 120, '2025-01-15', 'Compra proveedor'),
('MOV6', 'PR10', 'Entrada', 60, '2024-03-20', 'Nuevo lote'),
('MOV7', 'PR8', 'Entrada', 20, '2024-03-10', 'Stock limitado'),
('MOV8', 'PR5', 'Salida', 1, '2025-04-25', 'Venta Ord_8'),
('MOV9', 'PR7', 'Salida', 4, '2025-05-12', 'Venta Ord_7'),
('MOV10', 'PR8', 'Salida', 2, '2024-06-10', 'Venta Ord_9');
GO


SELECT * FROM dbo.Cliente;
SELECT * FROM dbo.Proveedor;
SELECT * FROM dbo.Categoria;
SELECT * FROM dbo.Franquicia;
SELECT * FROM dbo.Producto;
SELECT * FROM dbo.Empleado;
SELECT * FROM dbo.Orden;
SELECT * FROM dbo.Detalle_Orden;
SELECT * FROM dbo.Inventario_Movimientos;
