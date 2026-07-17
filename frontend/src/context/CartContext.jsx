import { createContext, useContext, useEffect, useMemo, useState } from 'react';

const CartContext = createContext(null);
const STORAGE_KEY = 'broken-pocket-cart';

export function CartProvider({ children }) {
  const [items, setItems] = useState(() => {
    try {
      return JSON.parse(localStorage.getItem(STORAGE_KEY) || '[]');
    } catch {
      return [];
    }
  });

  useEffect(() => {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(items));
  }, [items]);

  const addItem = (producto, cantidad = 1) => {
    setItems((prev) => {
      const existing = prev.find((i) => i.id_producto === producto.id_producto);
      if (existing) {
        const newQty = Math.min(existing.cantidad + cantidad, producto.stock);
        return prev.map((i) =>
          i.id_producto === producto.id_producto ? { ...i, cantidad: newQty, stock: producto.stock } : i
        );
      }
      return [
        ...prev,
        {
          id_producto: producto.id_producto,
          nombre_producto: producto.nombre_producto,
          precio: producto.precio,
          stock: producto.stock,
          nombre_categoria: producto.nombre_categoria,
          nombre_franquicia: producto.nombre_franquicia,
          cantidad: Math.min(cantidad, producto.stock),
        },
      ];
    });
  };

  const updateQuantity = (id, cantidad) => {
    setItems((prev) =>
      prev
        .map((i) => (i.id_producto === id ? { ...i, cantidad: Math.min(Math.max(1, cantidad), i.stock) } : i))
        .filter((i) => i.cantidad > 0)
    );
  };

  const removeItem = (id) => setItems((prev) => prev.filter((i) => i.id_producto !== id));
  const clearCart = () => setItems([]);

  const total = useMemo(() => items.reduce((s, i) => s + i.precio * i.cantidad, 0), [items]);
  const itemCount = useMemo(() => items.reduce((s, i) => s + i.cantidad, 0), [items]);

  return (
    <CartContext.Provider value={{ items, addItem, updateQuantity, removeItem, clearCart, total, itemCount }}>
      {children}
    </CartContext.Provider>
  );
}

export function useCart() {
  const ctx = useContext(CartContext);
  if (!ctx) throw new Error('useCart debe usarse dentro de CartProvider');
  return ctx;
}
