import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import productosRouter from './routes/productos.js';
import categoriasRouter from './routes/categorias.js';
import franquiciasRouter from './routes/franquicias.js';
import ordenesRouter from './routes/ordenes.js';
import clientesRouter from './routes/clientes.js';
import empleadosRouter from './routes/empleados.js';
import proveedoresRouter from './routes/proveedores.js';
import inventarioRouter from './routes/inventario.js';
import { getPool } from './db/pool.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

app.get('/', (_req, res) => {
  res.json({ name: 'Broken Pocket API', status: 'running' });
});

app.get('/api/health', async (_req, res) => {
  try {
    const pool = await getPool();
    await pool.request().query('SELECT 1 AS ok');
    res.json({ status: 'ok', database: 'connected' });
  } catch (err) {
    res.status(503).json({ status: 'error', database: 'disconnected', error: err.message });
  }
});

// Rutas de API
app.use('/api/productos', productosRouter);
app.use('/api/categorias', categoriasRouter);
app.use('/api/franquicias', franquiciasRouter);
app.use('/api/ordenes', ordenesRouter);
app.use('/api/clientes', clientesRouter);
app.use('/api/empleados', empleadosRouter);
app.use('/api/proveedores', proveedoresRouter);
app.use('/api/inventario', inventarioRouter);

app.use((_req, res) => {
  res.status(404).json({ error: 'Ruta no encontrada.' });
});

app.listen(PORT, () => {
  console.log(`Broken Pocket API en http://localhost:${PORT}`);
});
