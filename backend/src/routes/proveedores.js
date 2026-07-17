import { Router } from 'express';
import { getPool, sql } from '../db/pool.js';

const router = Router();

// GET: Listar todos los proveedores
router.get('/', async (_req, res) => {
  try {
    const pool = await getPool();
    const result = await pool.request().execute('sp_ListarProveedores');
    res.json(result.recordset);
  } catch (err) {
    console.error('GET /proveedores error:', err);
    res.status(500).json({ error: 'Error al obtener proveedores.' });
  }
});

// GET: Obtener un proveedor por ID
router.get('/:id', async (req, res) => {
  try {
    const pool = await getPool();
    const result = await pool
      .request()
      .input('id_proveedor', sql.NVarChar(20), req.params.id)
      .execute('sp_ObtenerProveedor');

    if (result.recordset.length === 0) {
      return res.status(404).json({ error: 'Proveedor no encontrado.' });
    }
    res.json(result.recordset[0]);
  } catch (err) {
    console.error('GET /proveedores/:id error:', err);
    res.status(500).json({ error: 'Error al obtener el proveedor.' });
  }
});

// POST: Crear un nuevo proveedor
router.post('/', async (req, res) => {
  try {
    const { id_proveedor, nombre_proveedor, contacto, telefono, pais, correo } = req.body;

    if (!id_proveedor || !nombre_proveedor || !correo) {
      return res.status(400).json({ 
        error: 'Campos requeridos: id_proveedor, nombre_proveedor, correo' 
      });
    }

    const pool = await getPool();
    await pool
      .request()
      .input('id_proveedor', sql.NVarChar(20), id_proveedor)
      .input('nombre_proveedor', sql.NVarChar(100), nombre_proveedor)
      .input('contacto', sql.NVarChar(50), contacto || null)
      .input('telefono', sql.NVarChar(30), telefono || null)
      .input('pais', sql.NVarChar(50), pais || null)
      .input('correo', sql.NVarChar(100), correo)
      .execute('sp_InsertarProveedor');

    res.status(201).json({ message: 'Proveedor creado exitosamente.', id_proveedor });
  } catch (err) {
    console.error('POST /proveedores error:', err);
    const errorMsg = err.message || 'Error al crear el proveedor.';
    res.status(500).json({ error: errorMsg });
  }
});

// PUT: Actualizar un proveedor
router.put('/:id', async (req, res) => {
  try {
    const { nombre_proveedor, contacto, telefono, pais, correo } = req.body;

    const pool = await getPool();
    await pool
      .request()
      .input('id_proveedor', sql.NVarChar(20), req.params.id)
      .input('nombre_proveedor', sql.NVarChar(100), nombre_proveedor || null)
      .input('contacto', sql.NVarChar(50), contacto || null)
      .input('telefono', sql.NVarChar(30), telefono || null)
      .input('pais', sql.NVarChar(50), pais || null)
      .input('correo', sql.NVarChar(100), correo || null)
      .execute('sp_ActualizarProveedor');

    res.json({ message: 'Proveedor actualizado exitosamente.', id_proveedor: req.params.id });
  } catch (err) {
    console.error('PUT /proveedores/:id error:', err);
    const errorMsg = err.message || 'Error al actualizar el proveedor.';
    res.status(500).json({ error: errorMsg });
  }
});

// DELETE: Eliminar un proveedor
router.delete('/:id', async (req, res) => {
  try {
    const pool = await getPool();
    await pool
      .request()
      .input('id_proveedor', sql.NVarChar(20), req.params.id)
      .execute('sp_EliminarProveedor');

    res.json({ message: 'Proveedor eliminado exitosamente.' });
  } catch (err) {
    console.error('DELETE /proveedores/:id error:', err);
    const errorMsg = err.message || 'Error al eliminar el proveedor.';
    res.status(500).json({ error: errorMsg });
  }
});

export default router;
