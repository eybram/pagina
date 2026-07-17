import { Router } from 'express';
import { getPool, sql } from '../db/pool.js';

const router = Router();

// GET: Listar productos (con filtros opcionales)
router.get('/', async (req, res) => {
  try {
    const pool = await getPool();
    let query = `
      SELECT
        p.id_producto,
        p.nombre_producto,
        p.id_categoria,
        p.id_franquicia,
        p.precio,
        p.stock,
        p.id_proveedor,
        c.nombre_categoria,
        f.nombre_franquicia
      FROM Producto p
      INNER JOIN Categoria c ON p.id_categoria = c.id_categoria
      LEFT JOIN Franquicia f ON p.id_franquicia = f.id_franquicia
      WHERE 1=1
    `;
    
    let request = pool.request();

    if (req.query.categoria) {
      query += ' AND p.id_categoria = @categoria';
      request = request.input('categoria', sql.NVarChar(20), req.query.categoria);
    }
    if (req.query.franquicia) {
      query += ' AND p.id_franquicia = @franquicia';
      request = request.input('franquicia', sql.NVarChar(20), req.query.franquicia);
    }
    if (req.query.q) {
      query += ' AND p.nombre_producto LIKE @q';
      request = request.input('q', sql.NVarChar(100), `%${req.query.q}%`);
    }

    query += ' ORDER BY p.nombre_producto';
    const result = await request.query(query);
    res.json(result.recordset);
  } catch (err) {
    console.error('GET /productos error:', err);
    res.status(500).json({ error: 'Error al obtener productos.' });
  }
});

// GET: Obtener un producto por ID
router.get('/:id', async (req, res) => {
  try {
    const pool = await getPool();
    const result = await pool
      .request()
      .input('id_producto', sql.NVarChar(20), req.params.id)
      .execute('sp_ObtenerProducto');

    if (result.recordset.length === 0) {
      return res.status(404).json({ error: 'Producto no encontrado.' });
    }
    res.json(result.recordset[0]);
  } catch (err) {
    console.error('GET /productos/:id error:', err);
    res.status(500).json({ error: 'Error al obtener el producto.' });
  }
});

// POST: Crear un nuevo producto
router.post('/', async (req, res) => {
  try {
    const { id_producto, nombre_producto, id_categoria, id_franquicia, precio, stock, id_proveedor } = req.body;

    if (!id_producto || !nombre_producto || !id_categoria || !precio || !id_proveedor) {
      return res.status(400).json({ 
        error: 'Campos requeridos: id_producto, nombre_producto, id_categoria, precio, id_proveedor' 
      });
    }

    const pool = await getPool();
    const result = await pool
      .request()
      .input('id_producto', sql.NVarChar(20), id_producto)
      .input('nombre_producto', sql.NVarChar(100), nombre_producto)
      .input('id_categoria', sql.NVarChar(20), id_categoria)
      .input('id_franquicia', sql.NVarChar(20), id_franquicia || null)
      .input('precio', sql.Decimal(10, 2), precio)
      .input('stock', sql.Int, stock || 0)
      .input('id_proveedor', sql.NVarChar(20), id_proveedor)
      .execute('sp_InsertarProducto');

    res.status(201).json({ message: 'Producto creado exitosamente.', id_producto });
  } catch (err) {
    console.error('POST /productos error:', err);
    const errorMsg = err.message || 'Error al crear el producto.';
    res.status(500).json({ error: errorMsg });
  }
});

// PUT: Actualizar un producto
router.put('/:id', async (req, res) => {
  try {
    const { nombre_producto, id_categoria, id_franquicia, precio, stock, id_proveedor } = req.body;

    const pool = await getPool();
    const result = await pool
      .request()
      .input('id_producto', sql.NVarChar(20), req.params.id)
      .input('nombre_producto', sql.NVarChar(100), nombre_producto || null)
      .input('id_categoria', sql.NVarChar(20), id_categoria || null)
      .input('id_franquicia', sql.NVarChar(20), id_franquicia || null)
      .input('precio', sql.Decimal(10, 2), precio !== undefined ? precio : null)
      .input('stock', sql.Int, stock !== undefined ? stock : null)
      .input('id_proveedor', sql.NVarChar(20), id_proveedor || null)
      .execute('sp_ActualizarProducto');

    res.json({ message: 'Producto actualizado exitosamente.', id_producto: req.params.id });
  } catch (err) {
    console.error('PUT /productos/:id error:', err);
    const errorMsg = err.message || 'Error al actualizar el producto.';
    res.status(500).json({ error: errorMsg });
  }
});

export default router;
