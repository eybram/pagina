import { Link } from 'react-router-dom';
import { useCart } from '../context/CartContext';

export default function ProductCard({ producto }) {
  const { addItem } = useCart();
  const lowStock = producto.stock > 0 && producto.stock <= 10;
  const outOfStock = producto.stock === 0;

  return (
    <article className="product-card">
      <div className="product-image" aria-hidden="true">
        {producto.nombre_categoria?.[0] || '?'}
      </div>
      <div className="product-body">
        <span className="product-tag">{producto.nombre_franquicia}</span>
        <h3>
          <Link to={`/producto/${producto.id_producto}`}>{producto.nombre_producto}</Link>
        </h3>
        <p className="product-meta">{producto.nombre_categoria}</p>
        <div className="product-footer">
          <span className="price">${producto.precio.toFixed(2)}</span>
          <span className={`stock ${outOfStock ? 'out' : lowStock ? 'low' : ''}`}>
            {outOfStock ? 'Agotado' : `${producto.stock} en stock`}
          </span>
        </div>
        <button
          type="button"
          className="btn btn-primary btn-block"
          disabled={outOfStock}
          onClick={() => addItem(producto)}
        >
          Agregar al carrito
        </button>
      </div>
    </article>
  );
}
