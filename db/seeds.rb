# Dependencias con relaciones de claves foráneas
ProductList.delete_all
SupplyList.delete_all

# Dependientes directos
Order.delete_all
Product.delete_all
Supply.delete_all
User.delete_all

# Tablas principales
Business.delete_all

# Crear negocio
cutefits = Business.create(name: 'Cutefits')

# Crear usuario
vicente = User.create(email: 'vicho@gmail.com', password: 'skibidi', business: cutefits)

# Crear insumos (supplies)
poleras = 10.times.map do |i|
  size = ['XS', 'S', 'M', 'L', 'XL', 'XXL'].sample
  Supply.create(
    name: "Polera color#{i + 1} talla S",
    business: cutefits,
    cost: 2990,
    stock: rand(5..10), # Stock aleatorio entre 5 y 10
    tipo1: 'Polera',
    tipo2: "Color#{i + 1}", # Diferentes colores
    tipo3: size,
    requires: 1
  )
end

impresion_supplies = %w[A B C D E F G H I J].map do |letra|
  Supply.create(
    business: cutefits,
    cost: 1200,
    stock: rand(5..10), # Stock aleatorio entre 5 y 10
    tipo1: letra,
    tipo2: 'DTF',
    tipo3: nil,
    name: "Diseño DTF #{letra}",
    requires: rand(1..4)
  )
end

# Crear 20 productos, cada uno con una polera y una impresión
products = []
created_product_names = Set.new # Usamos un conjunto para rastrear los nombres de los productos creados

20.times do
  polera = poleras.sample
  impresion = impresion_supplies.sample

  product_name = "Polera #{polera.tipo2} + Impresión #{impresion.tipo1}"

  # Verificar si el producto ya fue creado
  unless created_product_names.include?(product_name)
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
    created_product_names.add(product_name) # Añadir el nombre del producto al conjunto
  end
end

# Crear 5 órdenes con productos aleatorios
orders = []
5.times do
  order = Order.create(
    business: cutefits,
    name: "Orden #{rand(1000..9999)}",
    price: products.sample(5).sum(&:price), # Precio aleatorio basado en 5 productos
    production_cost: products.sample(5).sum { |p| p.supplies.sum(&:cost) },
    net_profit: products.sample(5).sum(&:price) - products.sample(5).sum { |p| p.supplies.sum(&:cost) },
    state: ["Pending", "Completed"].sample # Estado aleatorio
  )

  # Crear una ProductList y asociar los productos a la orden
  product_list = ProductList.create(order: order)
  product_list.products << products.sample(5) # Añadir 5 productos aleatorios a la orden

  orders << order
end

puts("LISTA DE PRODUCTOS CREADOS POR LA SEED")
puts(products.inspect)

puts("LISTA DE ÓRDENES CREADAS POR LA SEED")
puts(orders.inspect)

puts "Seed de cutefits exitosa"
