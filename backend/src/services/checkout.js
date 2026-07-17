import { getPool, sql } from '../db/pool.js';

const METODOS_PAGO = ['Efectivo', 'Tarjeta', 'Transferencia', 'PayPal', 'Yappy'];

function createError(message, statusCode = 400) {
  const err = new Error(message);
  err.statusCode = statusCode;
  return err;
}

async function generateId(prefix, table, column, transaction) {
  const result = await new sql.Request(transaction).query(
    `SELECT MAX(CAST(SUBSTRING(${column}, LEN('${prefix}') + 1, 20) AS INT)) AS maxNum FROM ${table} WHERE ${column} LIKE '${prefix}%'`
  );
  const next = (result.recordset[0]?.maxNum || 0) + 1;
  return `${prefix}${next}`;
}

async function generateOrdenId(transaction) {
  const result = await new sql.Request(transaction).query(
    `SELECT MAX(CAST(REPLACE(id_orden, 'Ord_', '') AS INT)) AS maxNum FROM Orden WHERE id_orden LIKE 'Ord_%'`
  );
  const next = (result.recordset[0]?.maxNum || 0) + 1;
  return `Ord_${next}`;
}

async function generateMovId(transaction) {
  const result = await new sql.Request(transaction).query(
    `SELECT MAX(CAST(SUBSTRING(id_mov, 4, 20) AS INT)) AS maxNum FROM Inventario_Movimientos WHERE id_mov LIKE 'MOV%'`
  );
  const next = (result.recordset[0]?.maxNum || 0) + 1;
  return `MOV${next}`;
}

export async function processCheckout({ cliente, metodo_pago, items }) {
  if (!cliente?.nombre || !cliente?.apellido || !cliente?.cedula || !cliente?.correo) {
    throw createError('Nombre, apellido, cédula y correo son obligatorios.');
  }
  if (!METODOS_PAGO.includes(metodo_pago)) {
    throw createError(`Método de pago inválido. Opciones: ${METODOS_PAGO.join(', ')}`);
  }
  if (!items?.length) {
    throw createError('El carrito está vacío.');
  }

  const pool = await getPool();
  const transaction = new sql.Transaction(pool);

  try {
    await transaction.begin();

    // Buscar o crear cliente
    let idCliente;
    const existing = await new sql.Request(transaction)
      .input('cedula', sql.NVarChar(20), cliente.cedula)
      .query('SELECT id_cliente FROM Cliente WHERE cedula = @cedula');

    if (existing.recordset.length > 0) {
      idCliente = existing.recordset[0].id_cliente;
    } else {
      idCliente = await generateId('Pd', 'Cliente', 'id_cliente', transaction);
      await new sql.Request(transaction)
        .input('id_cliente', sql.NVarChar(20), idCliente)
        .input('nombre', sql.NVarChar(50), cliente.nombre)
        .input('apellido', sql.NVarChar(50), cliente.apellido)
        .input('cedula', sql.NVarChar(20), cliente.cedula)
        .input('correo', sql.NVarChar(100), cliente.correo)
        .input('telefono', sql.NVarChar(20), cliente.telefono || null)
        .input('provincia', sql.NVarChar(50), cliente.provincia || null)
        .query(`
          INSERT INTO Cliente (id_cliente, nombre, apellido, cedula, correo, telefono, provincia, fecha_registro)
          VALUES (@id_cliente, @nombre, @apellido, @cedula, @correo, @telefono, @provincia, GETDATE())
        `);
    }

    // Validar stock y calcular total
    let total = 0;
    const lineItems = [];

    for (const item of items) {
      const productResult = await new sql.Request(transaction)
        .input('id_producto', sql.NVarChar(20), item.id_producto)
        .query('SELECT id_producto, nombre_producto, precio, stock FROM Producto WHERE id_producto = @id_producto');

      if (productResult.recordset.length === 0) {
        throw createError(`Producto ${item.id_producto} no encontrado.`);
      }

      const product = productResult.recordset[0];
      const cantidad = Number(item.cantidad);
      const precioUnitario = Number(item.precio_unitario ?? product.precio);

      if (cantidad <= 0) throw createError('La cantidad debe ser mayor a 0.');
      if (precioUnitario <= 0) throw createError('El precio unitario debe ser mayor a 0.');
      if (product.stock < cantidad) {
        throw createError(`Stock insuficiente para "${product.nombre_producto}" (disponible: ${product.stock}).`);
      }

      const subtotal = cantidad * precioUnitario;
      total += subtotal;
      lineItems.push({ ...item, cantidad, precio_unitario: precioUnitario, subtotal, stock: product.stock });
    }

    const idOrden = await generateOrdenId(transaction);
    const idEmpleado = process.env.DEFAULT_EMPLEADO_ID || 'EMP4';

    await new sql.Request(transaction)
      .input('id_orden', sql.NVarChar(20), idOrden)
      .input('id_cliente', sql.NVarChar(20), idCliente)
      .input('id_empleado', sql.NVarChar(20), idEmpleado)
      .input('total', sql.Decimal(10, 2), total)
      .input('metodo_pago', sql.NVarChar(20), metodo_pago)
      .query(`
        INSERT INTO Orden (id_orden, id_cliente, id_empleado, fecha_orden, total, metodo_pago)
        VALUES (@id_orden, @id_cliente, @id_empleado, GETDATE(), @total, @metodo_pago)
      `);

    for (const item of lineItems) {
      await new sql.Request(transaction)
        .input('id_orden', sql.NVarChar(20), idOrden)
        .input('id_producto', sql.NVarChar(20), item.id_producto)
        .input('cantidad', sql.Int, item.cantidad)
        .input('precio_unitario', sql.Decimal(10, 2), item.precio_unitario)
        .input('subtotal', sql.Decimal(10, 2), item.subtotal)
        .query(`
          INSERT INTO Detalle_Orden (id_orden, id_producto, cantidad, precio_unitario, subtotal)
          VALUES (@id_orden, @id_producto, @cantidad, @precio_unitario, @subtotal)
        `);

      await new sql.Request(transaction)
        .input('id_producto', sql.NVarChar(20), item.id_producto)
        .input('cantidad', sql.Int, item.cantidad)
        .query('UPDATE Producto SET stock = stock - @cantidad WHERE id_producto = @id_producto');

      const idMov = await generateMovId(transaction);
      await new sql.Request(transaction)
        .input('id_mov', sql.NVarChar(20), idMov)
        .input('id_producto', sql.NVarChar(20), item.id_producto)
        .input('cantidad', sql.Int, item.cantidad)
        .input('id_orden', sql.NVarChar(20), idOrden)
        .query(`
          INSERT INTO Inventario_Movimientos (id_mov, id_producto, tipo_movimiento, cantidad, fecha_movimiento, descripcion)
          VALUES (@id_mov, @id_producto, 'Salida', @cantidad, GETDATE(), CONCAT('Venta ', @id_orden))
        `);
    }

    await transaction.commit();
    return { id_orden: idOrden, id_cliente: idCliente, total };
  } catch (err) {
    await transaction.rollback();
    throw err;
  }
}
