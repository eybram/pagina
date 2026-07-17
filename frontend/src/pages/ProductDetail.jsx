import { useEffect, useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import Loading from '../components/Loading';
import ErrorMessage from '../components/ErrorMessage';
import { useCart } from '../context/CartContext';
import { getProducto } from '../services/api';

export default function ProductDetail() {
  const { id } = useParams();
  const { addItem } = useCart();
  const [producto, setProducto] = useState(null);
  const [cantidad, setCantidad] = useState(1);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    setLoading(true);
    getProducto(id)
      .then(setProducto)
      .catch((e) => setError(e.message))
      .finally(() => setLoading(false));
  }, [id]);

  if (loading) return <Loading />;
  if (error) return <main className="page"><ErrorMessage message={error} /><Link to="/">Volver al catálogo</Link></main>;
  if (!producto) return null;

  const outOfStock = producto.stock === 0;

  return (
    <main className="page product-detail">
      <Link to="/" className="back-link">← Volver al catálogo</Link>
      <div className="detail-layout">
        <div className="detail-image" aria-hidden="true">
          {producto.nombre_categoria?.[0]}
        </div>
        <div className="detail-info">
          <span className="product-tag">{producto.nombre_franquicia}</span>
          <h1>{producto.nombre_producto}</h1>
          <p className="product-meta">{producto.nombre_categoria}</p>
          <p className="price large">${producto.precio.toFixed(2)}</p>
          <p className={`stock ${outOfStock ? 'out' : ''}`}>
            {outOfStock ? 'Agotado' : `${producto.stock} unidades disponibles`}
          </p>

          {!outOfStock && (
            <div className="quantity-row">
              <label htmlFor="qty">Cantidad</label>
              <input
                id="qty"
                type="number"
                min={1}
                max={producto.stock}
                value={cantidad}
                onChange={(e) => setCantidad(Math.min(producto.stock, Math.max(1, Number(e.target.value))))}
              />
              <button type="button" className="btn btn-primary" onClick={() => addItem(producto, cantidad)}>
                Agregar al carrito
              </button>
            </div>
          )}
        </div>
      </div>
    </main>
  );
}
