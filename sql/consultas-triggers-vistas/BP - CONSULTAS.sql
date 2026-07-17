/* ============ CONSULTAS ============ */

--1 muestra el nombre completo de cada cliente en mayúsculas
SELECT id_cliente, UPPER(CONCAT(nombre, ' ', apellido)) AS nombre_completo
FROM Cliente;
GO

--2 filtra los clientes cuyo teléfono es un número celular (empieza en 6)
SELECT nombre, apellido, telefono
FROM Cliente
WHERE LEFT(telefono, 1) = '6';
GO

--3 verifica si un cliente específico ya tiene compras registradas
IF EXISTS (SELECT 1 FROM Orden WHERE id_cliente = 'Pd1')
    PRINT 'El cliente Pd1 ya tiene compras registradas.';
ELSE
    PRINT 'El cliente Pd1 aún no ha comprado.';
GO

--4 calcula el valor total de inventario que suministra cada proveedor
SELECT pr.nombre_proveedor, SUM(p.precio * p.stock) AS valor_inventario
FROM Proveedor pr
JOIN Producto p ON p.id_proveedor = pr.id_proveedor
GROUP BY pr.nombre_proveedor
ORDER BY valor_inventario DESC;
GO

-- 5. Mostrar nombres de categorías en mayúsculas
SELECT UPPER(nombre_categoria) AS Categoria
FROM Categoria;

-- 6. Concatenar nombre y descripción de categoría
SELECT CONCAT(nombre_categoria,' - ',descripcion) AS Informacion
FROM Categoria;

-- 7. Mostrar las primeras tres letras del nombre de la categoría
SELECT LEFT(nombre_categoria,3) AS Abreviatura
FROM Categoria;

-- 8. Mostrar nombres de franquicias en mayúsculas
SELECT UPPER(nombre_franquicia) AS Franquicia
FROM Franquicia;

-- 9. Concatenar nombre de la franquicia con su casa matriz
SELECT CONCAT(nombre_franquicia,' (',casa_matriz,')') AS Franquicia
FROM Franquicia;

-- 10. Mostrar los primeros cinco caracteres de la casa matriz
SELECT LEFT(casa_matriz,5) AS Iniciales
FROM Franquicia;

-- 11. Mostrar un resumen de la categoría en mayúsculas
SELECT UPPER(CONCAT(nombre_categoria,' - ',LEFT(descripcion,10))) AS Resumen
FROM Categoria;

--12 Total y promedio gastado por cliente
SELECT
    c.nombre,
    c.apellido,
    SUM(o.total) AS TotalGastado,
    AVG(o.total) AS PromedioCompra
FROM Cliente c
INNER JOIN Orden o
ON c.id_cliente = o.id_cliente
GROUP BY
    c.nombre,
    c.apellido;
GO

--13 Verifica si existe una orden con más de 3 productos diferentes
IF EXISTS
(
    SELECT id_orden
    FROM Detalle_Orden
    GROUP BY id_orden
    HAVING COUNT(id_producto) > 3
)
    PRINT 'Existe al menos una orden con más de 3 productos.';
ELSE
    PRINT 'No existen órdenes con más de 3 productos.';
GO

--14 Órdenes que contienen más de un producto
SELECT
    id_orden,
    COUNT(id_producto) AS CantidadProductos
FROM Detalle_Orden
GROUP BY id_orden
HAVING COUNT(id_producto) > 1;
GO

--15 EMPLEADOS POR CARGO

SELECT
    cargo,
    COUNT(*) AS Cantidad
FROM Empleado
GROUP BY cargo;

--16 SALARIOS PROMEDIO POR CARGO

SELECT
    cargo,
    AVG(salario) AS SalarioPromedio
FROM Empleado
GROUP BY cargo;

--17 ORDENES POR EMPLEADOS

SELECT
    e.nombre,
    e.apellido,
    COUNT(o.id_orden) AS OrdenesAtendidas
FROM Empleado e
LEFT JOIN Orden o
ON e.id_empleado=o.id_empleado
GROUP BY
e.nombre,
e.apellido
ORDER BY OrdenesAtendidas DESC;

--18 TOP SALARIOS

SELECT TOP 1
    nombre,
    apellido,
    cargo,
    salario
FROM Empleado
ORDER BY salario DESC;


--19 Meses con movimientos
SELECT DISTINCT DATEPART(MONTH, fecha_movimiento) AS Mes_Movimiento 
FROM Inventario_Movimientos;

--20 Intersect de productos (ejemplo: productos que tuvieron entrada y salida)
SELECT id_producto FROM Inventario_Movimientos WHERE tipo_movimiento = 'Entrada'
INTERSECT
SELECT id_producto FROM Inventario_Movimientos WHERE tipo_movimiento = 'Salida';

--21 Productos con poco inventario
SELECT
    nombre_producto,
    stock
FROM Producto
WHERE stock < 30;
GO

--22 Cantidad de productos por categoría
SELECT
    c.nombre_categoria,
    COUNT(p.id_producto) AS CantidadProductos
FROM Categoria c
LEFT JOIN Producto p
ON c.id_categoria = p.id_categoria
GROUP BY c.nombre_categoria;
GO

--23 Total de órdenes por método de pago
SELECT
    metodo_pago,
    COUNT(*) AS TotalOrdenes
FROM Orden
GROUP BY metodo_pago;
GO

--24 Productos ordenados del más caro al más barato
SELECT
    nombre_producto,
    precio
FROM Producto
ORDER BY precio DESC;
GO

--25 Cantidad de movimientos de inventario por tipo
SELECT
    tipo_movimiento,
    COUNT(*) AS TotalMovimientos
FROM Inventario_Movimientos
GROUP BY tipo_movimiento;
GO