# Crear negocio
cutefits = Business.create(name: 'Cutefits')

# Crear usuario
vicente = User.create(email: 'vicho@gmail.com', password: '123456', business: cutefits)

# Crear insumos (supplies)
poleras = 5.times.map do |i|
  Supply.create(
    business: cutefits,
    cost: 2990,
    stock: 3,
    tipo1: 'Polera',
    tipo2: "Color#{i + 1}", # Diferentes colores
    tipo3: 'S'
  )
end

impresion_supplies = %w[A B C D E].map do |letra|
  Supply.create(
    business: cutefits,
    cost: 1200,
    stock: 3,
    tipo1: letra,
    tipo2: 'DTF',
    tipo3: nil
  )
end

# Crear 5 productos, cada uno con una polera y una impresión
products = []
5.times do
  polera = poleras.sample
  impresion = impresion_supplies.sample

  product_name = "Polera #{polera.tipo2} + Impresión #{impresion.tipo1}"
  
  product = Product.create(
    business: cutefits,
    price: (polera.cost + impresion.cost) * 2, # Precio basado en los costos
    name: product_name
  )

  # Crear SupplyList para este producto y agregar la polera y la impresión
  supply_list = SupplyList.create(product: product)
  supply_list.supplies << polera
  supply_list.supplies << impresion

  products << product
end

# Crear una orden
order = Order.create(
  business: cutefits,
  name: 'Primera Orden',
  price: products.sum(&:price),
  production_cost: products.sum { |p| p.supplies.sum(&:cost) },
  net_profit: products.sum(&:price) - products.sum { |p| p.supplies.sum(&:cost) }
)

# Crear una ProductList y asociar los productos a la orden
product_list = ProductList.create(order: order)
product_list.products << products

puts "Seed de cutefits exitosa"
