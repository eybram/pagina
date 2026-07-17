import { Router } from 'express';
import { getPool, sql } from '../db/pool.js';

const router = Router();

// GET: Listar todos los movimientos de inventario
router.get('/', async (_req, res) => {
  try {
    const pool = await getPool();
    const result = await pool.request().execute('sp_ListarMovimientos');
    res.json(result.recordset);
  } catch (err) {
    console.error('GET /inventario error:', err);
    res.status(500).json({ error: 'Error al obtener movimientos de inventario.' });
  }
});

// GET: Obtener un movimiento de inventario por ID
router.get('/:id', async (req, res) => {
  try {
    const pool = await getPool();
    const result = await pool
      .request()
      .input('id_mov', sql.NVarChar(20), req.params.id)
      .execute('sp_ObtenerMovimiento');

    if (result.recordset.length === 0) {
      return res.status(404).json({ error: 'Movimiento de inventario no encontrado.' });
    }
    res.json(result.recordset[0]);
  } catch (err) {
    console.error('GET /inventario/:id error:', err);
    res.status(500).json({ error: 'Error al obtener el movimiento de inventario.' });
  }
});

// POST: Crear un nuevo movimiento de inventario
router.post('/', async (req, res) => {
  try {
    const { id_mov, id_producto, tipo, cantidad, desc } = req.body;

    if (!id_mov || !id_producto || !tipo || !cantidad) {
      return res.status(400).json({ 
        error: 'Campos requeridos: id_mov, id_producto, tipo, cantidad' 
      });
    }

    const pool = await getPool();
    await pool
      .request()
      .input('id_mov', sql.NVarChar(20), id_mov)
      .input('id_producto', sql.NVarChar(20), id_producto)
      .input('tipo', sql.NVarChar(20), tipo)
      .input('cantidad', sql.Int, cantidad)
      .input('desc', sql.NVarChar(200), desc || null)
      .execute('sp_InsertarMovimiento');

    res.status(201).json({ message: 'Movimiento de inventario creado exitosamente.', id_mov });
  } catch (err) {
    console.error('POST /inventario error:', err);
    const errorMsg = err.message || 'Error al crear el movimiento de inventario.';
    res.status(500).json({ error: errorMsg });
  }
});

// PUT: Actualizar un movimiento de inventario
router.put('/:id', async (req, res) => {
  try {
    const { cantidad, desc } = req.body;

    if (cantidad === undefined && !desc) {
      return res.status(400).json({ error: 'Al menos un campo es requerido para actualizar.' });
    }

    const pool = await getPool();
    await pool
      .request()
      .input('id_mov', sql.NVarChar(20), req.params.id)
      .input('cantidad', sql.Int, cantidad !== undefined ? cantidad : null)
      .input('desc', sql.NVarChar(200), desc || null)
      .execute('sp_ActualizarMovimiento');

    res.json({ message: 'Movimiento de inventario actualizado exitosamente.', id_mov: req.params.id });
  } catch (err) {
    console.error('PUT /inventario/:id error:', err);
    const errorMsg = err.message || 'Error al actualizar el movimiento de inventario.';
    res.status(500).json({ error: errorMsg });
  }
});

// DELETE: Eliminar un movimiento de inventario
router.delete('/:id', async (req, res) => {
  try {
    const pool = await getPool();
    await pool
      .request()
      .input('id_mov', sql.NVarChar(20), req.params.id)
      .execute('sp_EliminarMovimiento');

    res.json({ message: 'Movimiento de inventario eliminado exitosamente.' });
  } catch (err) {
    console.error('DELETE /inventario/:id error:', err);
    const errorMsg = err.message || 'Error al eliminar el movimiento de inventario.';
    res.status(500).json({ error: errorMsg });
  }
});

export default router;
