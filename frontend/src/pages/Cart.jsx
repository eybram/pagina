import { Link } from 'react-router-dom';
import { useCart } from '../context/CartContext';

export default function Cart() {
  const { items, updateQuantity, removeItem, total } = useCart();

  if (items.length === 0) {
    return (
      <main className="page">
        <h1>Carrito</h1>
        <p className="empty">Tu carrito está vacío.</p>
        <Link to="/" className="btn btn-primary">Ir al catálogo</Link>
      </main>
    );
  }

  return (
    <main className="page">
      <h1>Carrito</h1>
      <div className="cart-layout">
        <div className="cart-items">
          {items.map((item) => (
            <div key={item.id_producto} className="cart-item">
              <div>
                <h3>{item.nombre_producto}</h3>
                <p className="product-meta">{item.nombre_franquicia} · {item.nombre_categoria}</p>
                <p className="price">${item.precio.toFixed(2)} c/u</p>
              </div>
              <div className="cart-item-actions">
                <input
                  type="number"
                  min={1}
                  max={item.stock}
                  value={item.cantidad}
                  onChange={(e) => updateQuantity(item.id_producto, Number(e.target.value))}
                />
                <button type="button" className="btn btn-ghost" onClick={() => removeItem(item.id_producto)}>
                  Eliminar
                </button>
              </div>
              <p className="subtotal">${(item.precio * item.cantidad).toFixed(2)}</p>
            </div>
          ))}
        </div>
        <aside className="cart-summary">
          <h2>Resumen</h2>
          <div className="summary-row">
            <span>Subtotal</span>
            <span>${total.toFixed(2)}</span>
          </div>
          <div className="summary-row total">
            <span>Total</span>
            <span>${total.toFixed(2)}</span>
          </div>
          <Link to="/checkout" className="btn btn-primary btn-block">Proceder al checkout</Link>
        </aside>
      </div>
    </main>
  );
}
