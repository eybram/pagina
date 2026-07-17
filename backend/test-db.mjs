import sql from 'mssql';

const config = {
  server: 'DESKTOP-U7KEQSI',
  database: 'Broken Pocket',
  options: {
    trustedConnection: true,
    encrypt: false,
    trustServerCertificate: true,
    enableArithAbort: true,
  },
};

try {
  const pool = await sql.connect(config);
  const result = await pool.request().query('SELECT @@SERVERNAME AS serverName, DB_NAME() AS dbName, COUNT(*) AS totalProductos FROM dbo.Producto');
  console.log(JSON.stringify(result.recordset[0]));
  await pool.close();
} catch (err) {
  console.error(err.message);
  process.exit(1);
}
