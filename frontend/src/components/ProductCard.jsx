import { Link } from 'react-router-dom';
import { useCart } from '../context/CartContext';

export default function ProductCard({ producto }) {
  const { addItem } = useCart();
  const lowStock = producto.stock > 0 && producto.stock <= 10;
  const outOfStock = producto.stock === 0;
  const productImages = {
  PR1: 'https://tu-link-directo-a-la-imagen.jpg',
  PR2: 'https://tu-link-directo-a-la-imagen.jpg',
  PR3: 'https://tu-link-directo-a-la-imagen.jpg',
  PR4: 'https://tu-link-directo-a-la-imagen.jpg',
  PR5: 'https://tu-link-directo-a-la-imagen.jpg',
  PR6: 'https://tu-link-directo-a-la-imagen.jpg',
  PR7: 'https://tu-link-directo-a-la-imagen.jpg',
  PR8: 'https://tu-link-directo-a-la-imagen.jpg',
  PR9: 'https://tu-link-directo-a-la-imagen.jpg',
  PR10: 'https://tu-link-directo-a-la-imagen.jpg',
};

  return (
    <article className="product-card">
      <div className="product-image">
        <img
          src={productImages[producto.id_producto]}
          alt={producto.nombre_producto}
        />
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
