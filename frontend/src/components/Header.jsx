import { Link } from 'react-router-dom';
import { useCart } from '../context/CartContext';

export default function Header() {
  const { itemCount } = useCart();

  return (
    <header className="header">
      <div className="header-inner">
        <Link to="/" className="logo">
          <span className="logo-icon">🎮</span>
          <span>
            <strong>Broken Pocket</strong>
            <small>Tienda geek oficial</small>
          </span>
        </Link>
        <nav className="nav">
          <Link to="/">Catálogo</Link>
          <Link to="/carrito" className="cart-link">
            Carrito
            {itemCount > 0 && <span className="badge">{itemCount}</span>}
          </Link>
        </nav>
      </div>
    </header>
  );
}
