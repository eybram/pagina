import { Router } from 'express';
import { getPool, sql } from '../db/pool.js';

const router = Router();

// GET: Listar todas las franquicias
router.get('/', async (_req, res) => {
  try {
    const pool = await getPool();
    const result = await pool.request().execute('sp_ListarFranquicias');
    res.json(result.recordset);
  } catch (err) {
    console.error('GET /franquicias error:', err);
    res.status(500).json({ error: 'Error al obtener franquicias.' });
  }
});

// GET: Obtener una franquicia por ID
router.get('/:id', async (req, res) => {
  try {
    const pool = await getPool();
    const result = await pool
      .request()
      .input('id', sql.NVarChar(20), req.params.id)
      .execute('sp_ObtenerFranquicia');

    if (result.recordset.length === 0) {
      return res.status(404).json({ error: 'Franquicia no encontrada.' });
    }
    res.json(result.recordset[0]);
  } catch (err) {
    console.error('GET /franquicias/:id error:', err);
    res.status(500).json({ error: 'Error al obtener la franquicia.' });
  }
});

// POST: Crear una nueva franquicia
router.post('/', async (req, res) => {
  try {
    const { id, nombre, matriz } = req.body;

    if (!id || !nombre) {
      return res.status(400).json({ error: 'Campos requeridos: id, nombre' });
    }

    const pool = await getPool();
    await pool
      .request()
      .input('id', sql.NVarChar(20), id)
      .input('nombre', sql.NVarChar(50), nombre)
      .input('matriz', sql.NVarChar(50), matriz || null)
      .execute('sp_InsertarFranquicia');

    res.status(201).json({ message: 'Franquicia creada exitosamente.', id });
  } catch (err) {
    console.error('POST /franquicias error:', err);
    const errorMsg = err.message || 'Error al crear la franquicia.';
    res.status(500).json({ error: errorMsg });
  }
});

// PUT: Actualizar una franquicia
router.put('/:id', async (req, res) => {
  try {
    const { nombre, matriz } = req.body;

    const pool = await getPool();
    await pool
      .request()
      .input('id', sql.NVarChar(20), req.params.id)
      .input('nombre', sql.NVarChar(50), nombre || null)
      .input('matriz', sql.NVarChar(50), matriz || null)
      .execute('sp_ActualizarFranquicia');

    res.json({ message: 'Franquicia actualizada exitosamente.', id: req.params.id });
  } catch (err) {
    console.error('PUT /franquicias/:id error:', err);
    const errorMsg = err.message || 'Error al actualizar la franquicia.';
    res.status(500).json({ error: errorMsg });
  }
});

// DELETE: Eliminar una franquicia
router.delete('/:id', async (req, res) => {
  try {
    const pool = await getPool();
    await pool
      .request()
      .input('id', sql.NVarChar(20), req.params.id)
      .execute('sp_EliminarFranquicia');

    res.json({ message: 'Franquicia eliminada exitosamente.' });
  } catch (err) {
    console.error('DELETE /franquicias/:id error:', err);
    const errorMsg = err.message || 'Error al eliminar la franquicia.';
    res.status(500).json({ error: errorMsg });
  }
});

export default router;
