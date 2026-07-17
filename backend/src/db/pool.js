import sql from 'mssql';
import dotenv from 'dotenv';

dotenv.config();

const config = {
  server: process.env.DB_SERVER || 'DESKTOP-U7KEQSI',
  database: process.env.DB_DATABASE || 'Broken Pocket',
  user: process.env.DB_USER || undefined,
  password: process.env.DB_PASSWORD || undefined,
  port: Number(process.env.DB_PORT) || 1433,
  options: {
    trustedConnection: !process.env.DB_USER,
    encrypt: false,
    trustServerCertificate: true,
    enableArithAbort: true,
  },
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000,
  },
};

let pool = null;

export async function getPool() {
  if (!pool) {
    pool = await sql.connect(config);
  }
  return pool;
}

export { sql };

export function mapSqlError(err) {
  if (err.number === 2627 || err.number === 2601) {
    if (err.message.includes('Cedula')) return 'Ya existe un cliente con esa cédula.';
    if (err.message.includes('Correo')) return 'Ya existe un cliente con ese correo.';
    return 'Registro duplicado.';
  }
  if (err.number === 547) return 'Referencia inválida. Verifica los datos enviados.';
  if (err.number === 515) return 'Faltan campos obligatorios.';
  return err.message || 'Error en la base de datos.';
}
