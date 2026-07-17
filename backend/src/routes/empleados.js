import { Router } from 'express';
import { getPool, sql } from '../db/pool.js';

const router = Router();

// GET: Listar todos los empleados
router.get('/', async (_req, res) => {
  try {
    const pool = await getPool();
    const result = await pool.request().execute('sp_ListarEmpleados');
    res.json(result.recordset);
  } catch (err) {
    console.error('GET /empleados error:', err);
    res.status(500).json({ error: 'Error al obtener empleados.' });
  }
});

// GET: Obtener un empleado por ID
router.get('/:id', async (req, res) => {
  try {
    const pool = await getPool();
    const result = await pool
      .request()
      .input('id_empleado', sql.NVarChar(20), req.params.id)
      .execute('sp_ObtenerEmpleado');

    if (result.recordset.length === 0) {
      return res.status(404).json({ error: 'Empleado no encontrado.' });
    }
    res.json(result.recordset[0]);
  } catch (err) {
    console.error('GET /empleados/:id error:', err);
    res.status(500).json({ error: 'Error al obtener el empleado.' });
  }
});

// POST: Crear un nuevo empleado
router.post('/', async (req, res) => {
  try {
    const { id_empleado, nombre, apellido, cargo, correo, salario } = req.body;

    if (!id_empleado || !nombre || !apellido || !cargo || !correo || salario === undefined) {
      return res.status(400).json({ 
        error: 'Campos requeridos: id_empleado, nombre, apellido, cargo, correo, salario' 
      });
    }

    const pool = await getPool();
    await pool
      .request()
      .input('id_empleado', sql.NVarChar(20), id_empleado)
      .input('nombre', sql.NVarChar(50), nombre)
      .input('apellido', sql.NVarChar(50), apellido)
      .input('cargo', sql.NVarChar(50), cargo)
      .input('correo', sql.NVarChar(100), correo)
      .input('salario', sql.Decimal(10, 2), salario)
      .execute('sp_InsertarEmpleado');

    res.status(201).json({ message: 'Empleado creado exitosamente.', id_empleado });
  } catch (err) {
    console.error('POST /empleados error:', err);
    const errorMsg = err.message || 'Error al crear el empleado.';
    res.status(500).json({ error: errorMsg });
  }
});

// PUT: Actualizar un empleado
router.put('/:id', async (req, res) => {
  try {
    const { nombre, apellido, cargo, correo, salario } = req.body;

    const pool = await getPool();
    await pool
      .request()
      .input('id_empleado', sql.NVarChar(20), req.params.id)
      .input('nombre', sql.NVarChar(50), nombre || null)
      .input('apellido', sql.NVarChar(50), apellido || null)
      .input('cargo', sql.NVarChar(50), cargo || null)
      .input('correo', sql.NVarChar(100), correo || null)
      .input('salario', sql.Decimal(10, 2), salario !== undefined ? salario : null)
      .execute('sp_ActualizarEmpleado');

    res.json({ message: 'Empleado actualizado exitosamente.', id_empleado: req.params.id });
  } catch (err) {
    console.error('PUT /empleados/:id error:', err);
    const errorMsg = err.message || 'Error al actualizar el empleado.';
    res.status(500).json({ error: errorMsg });
  }
});

// DELETE: Eliminar un empleado
router.delete('/:id', async (req, res) => {
  try {
    const pool = await getPool();
    await pool
      .request()
      .input('id_empleado', sql.NVarChar(20), req.params.id)
      .execute('sp_EliminarEmpleado');

    res.json({ message: 'Empleado eliminado exitosamente.' });
  } catch (err) {
    console.error('DELETE /empleados/:id error:', err);
    const errorMsg = err.message || 'Error al eliminar el empleado.';
    res.status(500).json({ error: errorMsg });
  }
});

export default router;
