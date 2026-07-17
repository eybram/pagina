import { Router } from 'express';
import { getPool, sql } from '../db/pool.js';

const router = Router();

// GET: Listar todas las categorías
router.get('/', async (_req, res) => {
  try {
    const pool = await getPool();
    const result = await pool.request().execute('sp_ListarCategorias');
    res.json(result.recordset);
  } catch (err) {
    console.error('GET /categorias error:', err);
    res.status(500).json({ error: 'Error al obtener categorías.' });
  }
});

// GET: Obtener una categoría por ID
router.get('/:id', async (req, res) => {
  try {
    const pool = await getPool();
    const result = await pool
      .request()
      .input('id', sql.NVarChar(20), req.params.id)
      .execute('sp_ObtenerCategoria');

    if (result.recordset.length === 0) {
      return res.status(404).json({ error: 'Categoría no encontrada.' });
    }
    res.json(result.recordset[0]);
  } catch (err) {
    console.error('GET /categorias/:id error:', err);
    res.status(500).json({ error: 'Error al obtener la categoría.' });
  }
});

// POST: Crear una nueva categoría
router.post('/', async (req, res) => {
  try {
    const { id, nombre, descripcion } = req.body;

    if (!id || !nombre) {
      return res.status(400).json({ error: 'Campos requeridos: id, nombre' });
    }

    const pool = await getPool();
    await pool
      .request()
      .input('id', sql.NVarChar(20), id)
      .input('nombre', sql.NVarChar(50), nombre)
      .input('descripcion', sql.NVarChar(150), descripcion || null)
      .execute('sp_InsertarCategoria');

    res.status(201).json({ message: 'Categoría creada exitosamente.', id });
  } catch (err) {
    console.error('POST /categorias error:', err);
    const errorMsg = err.message || 'Error al crear la categoría.';
    res.status(500).json({ error: errorMsg });
  }
});

// PUT: Actualizar una categoría
router.put('/:id', async (req, res) => {
  try {
    const { nombre, descripcion } = req.body;

    const pool = await getPool();
    await pool
      .request()
      .input('id', sql.NVarChar(20), req.params.id)
      .input('nombre', sql.NVarChar(50), nombre || null)
      .input('descripcion', sql.NVarChar(150), descripcion || null)
      .execute('sp_ActualizarCategoria');

    res.json({ message: 'Categoría actualizada exitosamente.', id: req.params.id });
  } catch (err) {
    console.error('PUT /categorias/:id error:', err);
    const errorMsg = err.message || 'Error al actualizar la categoría.';
    res.status(500).json({ error: errorMsg });
  }
});

// DELETE: Eliminar una categoría
router.delete('/:id', async (req, res) => {
  try {
    const pool = await getPool();
    await pool
      .request()
      .input('id', sql.NVarChar(20), req.params.id)
      .execute('sp_EliminarCategoria');

    res.json({ message: 'Categoría eliminada exitosamente.' });
  } catch (err) {
    console.error('DELETE /categorias/:id error:', err);
    const errorMsg = err.message || 'Error al eliminar la categoría.';
    res.status(500).json({ error: errorMsg });
  }
});

export default router;
