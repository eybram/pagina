import { productos as mockProductos, categorias as mockCategorias, franquicias as mockFranquicias } from '../mocks/data.js';

const API_BASE = import.meta.env.VITE_API_URL || 'http://localhost:3001/api';
const USE_MOCKS = import.meta.env.VITE_USE_MOCKS === 'true';

async function request(path, options = {}) {
  const res = await fetch(`${API_BASE}${path}`, {
    headers: { 'Content-Type': 'application/json', ...options.headers },
    ...options,
  });
  const data = await res.json().catch(() => ({}));
  if (!res.ok) {
    throw new Error(data.error || `Error ${res.status}`);
  }
  return data;
}

export async function getProductos(filters = {}) {
  if (USE_MOCKS) {
    let list = [...mockProductos];
    if (filters.categoria) list = list.filter((p) => p.id_categoria === filters.categoria);
    if (filters.franquicia) list = list.filter((p) => p.id_franquicia === filters.franquicia);
    if (filters.q) {
      const q = filters.q.toLowerCase();
      list = list.filter((p) => p.nombre_producto.toLowerCase().includes(q));
    }
    return list;
  }
  const params = new URLSearchParams();
  if (filters.categoria) params.set('categoria', filters.categoria);
  if (filters.franquicia) params.set('franquicia', filters.franquicia);
  if (filters.q) params.set('q', filters.q);
  const qs = params.toString();
  return request(`/productos${qs ? `?${qs}` : ''}`);
}

export async function getProducto(id) {
  if (USE_MOCKS) {
    const p = mockProductos.find((x) => x.id_producto === id);
    if (!p) throw new Error('Producto no encontrado');
    return p;
  }
  return request(`/productos/${id}`);
}

export async function getCategorias() {
  if (USE_MOCKS) return mockCategorias;
  return request('/categorias');
}

export async function getFranquicias() {
  if (USE_MOCKS) return mockFranquicias;
  return request('/franquicias');
}

export async function createOrden(payload) {
  if (USE_MOCKS) {
    return { id_orden: `Ord_mock_${Date.now()}`, total: payload.items.reduce((s, i) => s + i.precio_unitario * i.cantidad, 0) };
  }
  return request('/ordenes', { method: 'POST', body: JSON.stringify(payload) });
}
