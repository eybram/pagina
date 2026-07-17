export default function FilterBar({ categorias, franquicias, filters, onChange }) {
  return (
    <div className="filter-bar">
      <input
        type="search"
        placeholder="Buscar productos..."
        value={filters.q}
        onChange={(e) => onChange({ ...filters, q: e.target.value })}
        className="search-input"
      />
      <select
        value={filters.categoria}
        onChange={(e) => onChange({ ...filters, categoria: e.target.value })}
      >
        <option value="">Todas las categorías</option>
        {categorias.map((c) => (
          <option key={c.id_categoria} value={c.id_categoria}>
            {c.nombre_categoria}
          </option>
        ))}
      </select>
      <select
        value={filters.franquicia}
        onChange={(e) => onChange({ ...filters, franquicia: e.target.value })}
      >
        <option value="">Todas las franquicias</option>
        {franquicias.map((f) => (
          <option key={f.id_franquicia} value={f.id_franquicia}>
            {f.nombre_franquicia}
          </option>
        ))}
      </select>
    </div>
  );
}
