import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import ErrorMessage from '../components/ErrorMessage';
import { useCart } from '../context/CartContext';
import { createOrden } from '../services/api';
import { METODOS_PAGO, PROVINCIAS } from '../mocks/data';

const emptyCliente = {
  nombre: '',
  apellido: '',
  cedula: '',
  correo: '',
  telefono: '',
  provincia: '',
};

export default function Checkout() {
  const { items, total, clearCart } = useCart();
  const navigate = useNavigate();
  const [cliente, setCliente] = useState(emptyCliente);
  const [metodoPago, setMetodoPago] = useState('Tarjeta');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState(null);

  if (items.length === 0 && !success) {
    return (
      <main className="page">
        <h1>Checkout</h1>
        <p className="empty">No hay productos en el carrito.</p>
        <Link to="/" className="btn btn-primary">Ir al catálogo</Link>
      </main>
    );
  }

  const handleChange = (e) => {
    setCliente((prev) => ({ ...prev, [e.target.name]: e.target.value }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    try {
      const result = await createOrden({
        cliente,
        metodo_pago: metodoPago,
        items: items.map((i) => ({
          id_producto: i.id_producto,
          cantidad: i.cantidad,
          precio_unitario: i.precio,
        })),
      });
      setSuccess(result);
      clearCart();
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  if (success) {
    return (
      <main className="page checkout-success">
        <h1>¡Orden confirmada!</h1>
        <p>Tu orden <strong>{success.id_orden}</strong> fue registrada correctamente.</p>
        <p>Total: <strong>${Number(success.total).toFixed(2)}</strong></p>
        <button type="button" className="btn btn-primary" onClick={() => navigate('/')}>
          Seguir comprando
        </button>
      </main>
    );
  }

  return (
    <main className="page">
      <h1>Checkout</h1>
      <div className="checkout-layout">
        <form className="checkout-form" onSubmit={handleSubmit}>
          <h2>Datos del cliente</h2>
          <div className="form-grid">
            <label>
              Nombre *
              <input name="nombre" required maxLength={50} value={cliente.nombre} onChange={handleChange} />
            </label>
            <label>
              Apellido *
              <input name="apellido" required maxLength={50} value={cliente.apellido} onChange={handleChange} />
            </label>
            <label>
              Cédula *
              <input name="cedula" required maxLength={20} value={cliente.cedula} onChange={handleChange} />
            </label>
            <label>
              Correo *
              <input name="correo" type="email" required maxLength={100} value={cliente.correo} onChange={handleChange} />
            </label>
            <label>
              Teléfono
              <input name="telefono" maxLength={20} value={cliente.telefono} onChange={handleChange} />
            </label>
            <label>
              Provincia
              <select name="provincia" value={cliente.provincia} onChange={handleChange}>
                <option value="">Seleccionar...</option>
                {PROVINCIAS.map((p) => (
                  <option key={p} value={p}>{p}</option>
                ))}
              </select>
            </label>
          </div>

          <h2>Método de pago</h2>
          <div className="payment-options">
            {METODOS_PAGO.map((m) => (
              <label key={m} className="payment-option">
                <input
                  type="radio"
                  name="metodo_pago"
                  value={m}
                  checked={metodoPago === m}
                  onChange={() => setMetodoPago(m)}
                />
                {m}
              </label>
            ))}
          </div>

          <ErrorMessage message={error} />
          <button type="submit" className="btn btn-primary btn-block" disabled={loading}>
            {loading ? 'Procesando...' : `Confirmar orden — $${total.toFixed(2)}`}
          </button>
        </form>

        <aside className="cart-summary">
          <h2>Tu orden</h2>
          {items.map((item) => (
            <div key={item.id_producto} className="summary-item">
              <span>{item.nombre_producto} × {item.cantidad}</span>
              <span>${(item.precio * item.cantidad).toFixed(2)}</span>
            </div>
          ))}
          <div className="summary-row total">
            <span>Total</span>
            <span>${total.toFixed(2)}</span>
          </div>
        </aside>
      </div>
    </main>
  );
}
