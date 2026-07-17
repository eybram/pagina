export const categorias = [
  { id_categoria: 'CAT1', nombre_categoria: 'Camiseta', descripcion: 'Ropa estampada con diseños de franquicias geek' },
  { id_categoria: 'CAT2', nombre_categoria: 'Figura', descripcion: 'Figuras coleccionables y Funko Pop' },
  { id_categoria: 'CAT3', nombre_categoria: 'Llavero', descripcion: 'Llaveros coleccionables de personajes' },
  { id_categoria: 'CAT4', nombre_categoria: 'Poster', descripcion: 'Posters e ilustraciones decorativas' },
];

export const franquicias = [
  { id_franquicia: 'FR1', nombre_franquicia: 'Zelda', casa_matriz: 'Nintendo' },
  { id_franquicia: 'FR2', nombre_franquicia: 'God of War', casa_matriz: 'Sony Santa Monica' },
  { id_franquicia: 'FR3', nombre_franquicia: 'Pokémon', casa_matriz: 'Game Freak / Nintendo' },
  { id_franquicia: 'FR4', nombre_franquicia: 'Halo', casa_matriz: '343 Industries' },
  { id_franquicia: 'FR5', nombre_franquicia: 'Nintendo', casa_matriz: 'Nintendo' },
  { id_franquicia: 'FR6', nombre_franquicia: 'Bethesda', casa_matriz: 'Bethesda Softworks' },
  { id_franquicia: 'FR7', nombre_franquicia: 'Minecraft', casa_matriz: 'Mojang Studios' },
  { id_franquicia: 'FR8', nombre_franquicia: 'Hollow Knight', casa_matriz: 'Team Cherry' },
];

export const productos = [
  { id_producto: 'PR1', nombre_producto: 'Camiseta Zelda Master Sword', id_categoria: 'CAT1', id_franquicia: 'FR1', precio: 25.0, stock: 50, id_proveedor: 'EM1', nombre_categoria: 'Camiseta', nombre_franquicia: 'Zelda' },
  { id_producto: 'PR2', nombre_producto: 'Figura Funko de Kratos', id_categoria: 'CAT2', id_franquicia: 'FR2', precio: 35.0, stock: 30, id_proveedor: 'EM4', nombre_categoria: 'Figura', nombre_franquicia: 'God of War' },
  { id_producto: 'PR3', nombre_producto: 'Llavero Pokeball', id_categoria: 'CAT3', id_franquicia: 'FR3', precio: 10.0, stock: 80, id_proveedor: 'EM1', nombre_categoria: 'Llavero', nombre_franquicia: 'Pokémon' },
  { id_producto: 'PR4', nombre_producto: 'Poster Halo Infinite', id_categoria: 'CAT4', id_franquicia: 'FR4', precio: 12.0, stock: 40, id_proveedor: 'EM3', nombre_categoria: 'Poster', nombre_franquicia: 'Halo' },
  { id_producto: 'PR5', nombre_producto: 'Figura de Mario Kart', id_categoria: 'CAT2', id_franquicia: 'FR5', precio: 28.0, stock: 25, id_proveedor: 'EM1', nombre_categoria: 'Figura', nombre_franquicia: 'Nintendo' },
  { id_producto: 'PR6', nombre_producto: 'Camiseta de Starfield', id_categoria: 'CAT1', id_franquicia: 'FR6', precio: 22.0, stock: 35, id_proveedor: 'EM2', nombre_categoria: 'Camiseta', nombre_franquicia: 'Bethesda' },
  { id_producto: 'PR7', nombre_producto: 'Llavero de Creeper', id_categoria: 'CAT3', id_franquicia: 'FR7', precio: 8.0, stock: 120, id_proveedor: 'EM5', nombre_categoria: 'Llavero', nombre_franquicia: 'Minecraft' },
  { id_producto: 'PR8', nombre_producto: 'Figura Funko de Pikachu', id_categoria: 'CAT2', id_franquicia: 'FR3', precio: 32.0, stock: 20, id_proveedor: 'EM4', nombre_categoria: 'Figura', nombre_franquicia: 'Pokémon' },
  { id_producto: 'PR9', nombre_producto: 'Poster de God of War Ragnarok', id_categoria: 'CAT4', id_franquicia: 'FR2', precio: 15.0, stock: 18, id_proveedor: 'EM5', nombre_categoria: 'Poster', nombre_franquicia: 'God of War' },
  { id_producto: 'PR10', nombre_producto: 'Camiseta de Hollow Knight', id_categoria: 'CAT1', id_franquicia: 'FR8', precio: 20.0, stock: 60, id_proveedor: 'EM2', nombre_categoria: 'Camiseta', nombre_franquicia: 'Hollow Knight' },
];

export const METODOS_PAGO = ['Efectivo', 'Tarjeta', 'Transferencia', 'PayPal', 'Yappy'];

export const PROVINCIAS = [
  'Bocas del Toro', 'Coclé', 'Colón', 'Chiriquí', 'Darién',
  'Herrera', 'Los Santos', 'Panamá', 'Panamá Oeste', 'Veraguas',
];
