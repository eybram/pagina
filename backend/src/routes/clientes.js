import { Router } from 'express';
import { getPool, sql } from '../db/pool.js';

const router = Router();

// GET: Listar todos los clientes
router.get('/', async (_req, res) => {
  try {
    const pool = await getPool();
    const result = await pool.request().execute('sp_ListarClientes');
    res.json(result.recordset);
  } catch (err) {
    console.error('GET /clientes error:', err);
    res.status(500).json({ error: 'Error al obtener clientes.' });
  }
});

// GET: Obtener un cliente por ID
router.get('/:id', async (req, res) => {
  try {
    const pool = await getPool();
    const result = await pool
      .request()
      .input('id_cliente', sql.NVarChar(20), req.params.id)
      .execute('sp_ObtenerCliente');

    if (result.recordset.length === 0) {
      return res.status(404).json({ error: 'Cliente no encontrado.' });
    }
    res.json(result.recordset[0]);
  } catch (err) {
    console.error('GET /clientes/:id error:', err);
    res.status(500).json({ error: 'Error al obtener el cliente.' });
  }
});

// POST: Crear un nuevo cliente
router.post('/', async (req, res) => {
  try {
    const { id_cliente, nombre, apellido, cedula, correo, telefono, provincia } = req.body;

    if (!id_cliente || !nombre || !apellido || !cedula || !correo) {
      return res.status(400).json({ 
        error: 'Campos requeridos: id_cliente, nombre, apellido, cedula, correo' 
      });
    }

    const pool = await getPool();
    await pool
      .request()
      .input('id_cliente', sql.NVarChar(20), id_cliente)
      .input('nombre', sql.NVarChar(50), nombre)
      .input('apellido', sql.NVarChar(50), apellido)
      .input('cedula', sql.NVarChar(20), cedula)
      .input('correo', sql.NVarChar(100), correo)
      .input('telefono', sql.NVarChar(20), telefono || null)
      .input('provincia', sql.NVarChar(50), provincia || null)
      .execute('sp_InsertarCliente');

    res.status(201).json({ message: 'Cliente creado exitosamente.', id_cliente });
  } catch (err) {
    console.error('POST /clientes error:', err);
    const errorMsg = err.message || 'Error al crear el cliente.';
    res.status(500).json({ error: errorMsg });
  }
});

// PUT: Actualizar un cliente
router.put('/:id', async (req, res) => {
  try {
    const { nombre, apellido, cedula, correo, telefono, provincia } = req.body;

    const pool = await getPool();
    await pool
      .request()
      .input('id_cliente', sql.NVarChar(20), req.params.id)
      .input('nombre', sql.NVarChar(50), nombre || null)
      .input('apellido', sql.NVarChar(50), apellido || null)
      .input('cedula', sql.NVarChar(20), cedula || null)
      .input('correo', sql.NVarChar(100), correo || null)
      .input('telefono', sql.NVarChar(20), telefono || null)
      .input('provincia', sql.NVarChar(50), provincia || null)
      .execute('sp_ActualizarCliente');

    res.json({ message: 'Cliente actualizado exitosamente.', id_cliente: req.params.id });
  } catch (err) {
    console.error('PUT /clientes/:id error:', err);
    const errorMsg = err.message || 'Error al actualizar el cliente.';
    res.status(500).json({ error: errorMsg });
  }
});

// DELETE: Eliminar un cliente
router.delete('/:id', async (req, res) => {
  try {
    const pool = await getPool();
    await pool
      .request()
      .input('id_cliente', sql.NVarChar(20), req.params.id)
      .execute('sp_EliminarCliente');

    res.json({ message: 'Cliente eliminado exitosamente.' });
  } catch (err) {
    console.error('DELETE /clientes/:id error:', err);
    const errorMsg = err.message || 'Error al eliminar el cliente.';
    res.status(500).json({ error: errorMsg });
  }
});

export default router;
