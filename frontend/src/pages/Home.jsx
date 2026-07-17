import { useEffect, useState } from 'react';
import FilterBar from '../components/FilterBar';
import ProductCard from '../components/ProductCard';
import Loading from '../components/Loading';
import ErrorMessage from '../components/ErrorMessage';
import { getProductos, getCategorias, getFranquicias } from '../services/api';

export default function Home() {
  const [productos, setProductos] = useState([]);
  const [categorias, setCategorias] = useState([]);
  const [franquicias, setFranquicias] = useState([]);
  const [filters, setFilters] = useState({ q: '', categoria: '', franquicia: '' });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    Promise.all([getCategorias(), getFranquicias()])
      .then(([cats, frans]) => {
        setCategorias(cats);
        setFranquicias(frans);
      })
      .catch((e) => setError(e.message));
  }, []);

  useEffect(() => {
    setLoading(true);
    setError('');
    getProductos(filters)
      .then(setProductos)
      .catch((e) => setError(e.message))
      .finally(() => setLoading(false));
  }, [filters]);

  return (
    <main className="page">
      <section className="hero">
        <h1>Mercancía geek oficial</h1>
        <p>Figuras, anime, cómics, videojuegos y accesorios de tus franquicias favoritas.</p>
      </section>

      <FilterBar categorias={categorias} franquicias={franquicias} filters={filters} onChange={setFilters} />
      <ErrorMessage message={error} />

      {loading ? (
        <Loading />
      ) : productos.length === 0 ? (
        <p className="empty">No se encontraron productos.</p>
      ) : (
        <div className="product-grid">
          {productos.map((p) => (
            <ProductCard key={p.id_producto} producto={p} />
          ))}
        </div>
      )}
    </main>
  );
}
