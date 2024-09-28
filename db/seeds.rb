# Crear negocio
cutefits = Business.create(name: 'Cutefits')

# Crear usuario
vicente = User.create(email: 'vicho@gmail.com', password: 'skibidi', business: cutefits)

# Crear insumos (supplies)
poleras = 5.times.map do |i|
  Supply.create(
    name: "Polera color#{i + 1} talla S",
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
    tipo3: nil,
    name: "Diseño DTF #{letra}"
  )
end

# Crear 5 productos, cada uno con una polera y una impresión
products = []
created_product_names = Set.new # Usamos un conjunto para rastrear los nombres de los productos creados

5.times do
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
    puts("LISTA DE PRODUCTOS CREADOS POR LA SEED")
    puts(products.inspect)
  else
    puts("El producto '#{product_name}' ya existe, no se creará nuevamente.")
  end
end


# Crear una orden
order = Order.create(
  business: cutefits,
  name: 'Primera Orden',
  price: products.sum(&:price),
  production_cost: products.sum { |p| p.supplies.sum(&:cost) },
  net_profit: products.sum(&:price) - products.sum { |p| p.supplies.sum(&:cost) },
  state: "Pending"
)

# Crear una ProductList y asociar los productos a la orden
product_list = ProductList.create(order: order)
product_list.products << products

puts("LISTA DE PRODUCTOS CREADA POR LA SEED")
  puts(product_list.products.inspect)


puts "Seed de cutefits exitosa"
