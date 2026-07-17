import { processCheckout } from '../services/checkout.js';
import { mapSqlError, getPool, sql } from '../db/pool.js';
import { Router } from 'express';

const router = Router();

// GET: Listar todas las órdenes
router.get('/', async (req, res) => {
  try {
    const pool = await getPool();
    const result = await pool.request().execute('sp_ListarOrdenes');
    res.json(result.recordset);
  } catch (err) {
    console.error('GET /ordenes error:', err);
    res.status(500).json({ error: 'Error al obtener órdenes.' });
  }
});

// GET: Obtener una orden por ID
router.get('/:id', async (req, res) => {
  try {
    const pool = await getPool();
    const result = await pool
      .request()
      .input('id_orden', sql.NVarChar(20), req.params.id)
      .execute('sp_ObtenerOrden');

    if (result.recordset.length === 0) {
      return res.status(404).json({ error: 'Orden no encontrada.' });
    }
    res.json(result.recordset[0]);
  } catch (err) {
    console.error('GET /ordenes/:id error:', err);
    res.status(500).json({ error: 'Error al obtener la orden.' });
  }
});

// POST: Crear una nueva orden (checkout)
router.post('/', async (req, res) => {
  try {
    const { cliente, metodo_pago, items } = req.body;

    if (!cliente || !metodo_pago || !items?.length) {
      return res.status(400).json({ error: 'Cliente, método de pago e ítems son obligatorios.' });
    }

    const result = await processCheckout({ cliente, metodo_pago, items });
    res.status(201).json(result);
  } catch (err) {
    console.error('POST /ordenes error:', err);
    const message = err.statusCode ? err.message : mapSqlError(err);
    res.status(err.statusCode || 500).json({ error: message });
  }
});

// PUT: Actualizar una orden
router.put('/:id', async (req, res) => {
  try {
    const { total, metodo_pago } = req.body;

    if (total === undefined && !metodo_pago) {
      return res.status(400).json({ error: 'Al menos un campo es requerido para actualizar.' });
    }

    const pool = await getPool();
    await pool
      .request()
      .input('id_orden', sql.NVarChar(20), req.params.id)
      .input('total', sql.Decimal(10, 2), total !== undefined ? total : null)
      .input('metodo_pago', sql.NVarChar(20), metodo_pago || null)
      .execute('sp_ActualizarOrden');

    res.json({ message: 'Orden actualizada exitosamente.', id_orden: req.params.id });
  } catch (err) {
    console.error('PUT /ordenes/:id error:', err);
    const errorMsg = err.message || 'Error al actualizar la orden.';
    res.status(500).json({ error: errorMsg });
  }
});

// DELETE: Eliminar una orden
router.delete('/:id', async (req, res) => {
  try {
    const pool = await getPool();
    await pool
      .request()
      .input('id_orden', sql.NVarChar(20), req.params.id)
      .execute('sp_EliminarOrden');

    res.json({ message: 'Orden eliminada exitosamente.' });
  } catch (err) {
    console.error('DELETE /ordenes/:id error:', err);
    const errorMsg = err.message || 'Error al eliminar la orden.';
    res.status(500).json({ error: errorMsg });
  }
});

export default router;
