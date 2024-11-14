class OrdersController < ApplicationController

  def show
    @order = Order.find(params[:id])
  end

  
  def index
    @business = current_user.business
    puts current_user.inspect
    @orders = Order.where(business_id: @business.id)
    @product_lists = ProductList.joins(:order)
    .where(orders: { business_id: @business.id })
  end

  def new
    @business = current_user.business
    @order = Order.new
    @products = Product.where(business_id: @business.id)
    @next_order_id = Order.last.present? ? Order.last.id + 1 : 1
  end

  def create
    puts("PARAMS!")
    puts(params.inspect)
    puts("PARAMS!")
    @business = current_user.business
    product_names = params[:product_name]
    quantities = params[:quantity].map(&:to_i)
    
    products = Product.where(name: product_names).to_a
    puts("PRODUCTS!")
    puts(products.inspect)
    puts("QUANTITIES!")
    puts(quantities)
    total_price = products.each_with_index.sum { |product, index| product.price * quantities[index] }
    
    @order = Order.new(order_params)
    @order.business = @business
    @order.price = total_price
    @order.production_cost = 1 # Default value
    @order.net_profit = 1 # Default value
    @order.state = "Pending" #Default!!

    if @order.save
      product_list = ProductList.create(order: @order)
    
      product_names.each_with_index do |name, index|
        product = products.find { |p| p.name == name }
        puts("PRODUCT VAR:")
        puts(product.inspect)
    
        # Agregar el producto según la cantidad
        if product && quantities[index] > 0
          quantities[index].times do
            product_list.products << product
          end
        end
      end


  
      

      puts("PRODUCT LIST OFFICIALLY:")
      puts(product_list.products.inspect)
      redirect_to orders_path, notice: "Order created successfully."
    else
      render :new
    end
  end 
  def edit
    @business = current_user.business
    @order = Order.find(params[:id])
    @products = Product.all
    @order_quantities = calculate_quantities(@order)
  end
  
  def update
    @order = Order.find(params[:id])
    product_names = params[:product_name]
    quantities = params[:quantity].map(&:to_i)
  
    products = Product.where(name: product_names).to_a
    total_price = products.each_with_index.sum { |product, index| product.price * quantities[index] }
  
    @order.update(name: order_params[:name], price: total_price)
  
    # Actualizar la product_list asociada
    product_list = @order.product_list
    product_list.products.clear
  
    product_names.each_with_index do |name, index|
      product = products.find { |p| p.name == name }
      if product && quantities[index] > 0
        quantities[index].times do
          product_list.products << product
        end
      end
    end
  
    if @order.save
      redirect_to orders_path, notice: 'Order was successfully updated.'
    else
      render :edit
    end
  end

  def progress_state
    @order = Order.find(params[:id])
  
    if @order.state == 'Pending'
      # Verificar si hay stock suficiente para completar la orden
      if can_complete_order?(@order)
        # Proceder a descontar el stock y actualizar el estado
        product_list = ProductList.find_by(order_id: @order.id)
        products = product_list.products
  
        products.each do |product|
          supply_list = SupplyList.find_by(product_id: product.id)
          supplies = supply_list.supplies
          supplies.each do |supply|
            supply.update(stock: supply.stock - 1) if supply.stock > 0
          end
        end
  
        @order.update(state: 'Completed')
        redirect_to orders_path, notice: 'Order state updated to Completed and supplies updated.'
      else
        redirect_to orders_path, alert: 'No hay suficiente stock para completar la orden.'
      end
    else
      redirect_to orders_path, alert: 'Order state cannot be updated.'
    end
  end

  
  def destroy
    @order = Order.find(params[:id])
    if @order.destroy
      flash[:success] = 'Object was successfully deleted.'
      redirect_to orders_url
    else
      flash[:error] = 'Something went wrong'
      redirect_to orders_url
    end
  end
    
  private
  
  def calculate_quantities(order)
    # Count the number of instances of each product in the order using the join table
    order.product_list.products.group(:name).count
  end
  
  def set_business
    @business = current_user.business
  end
  def order_params
    params.require(:order).permit(:name)
  end
  def can_complete_order?(order)
    order.product_list.products.all? do |product|
      product.supply_list.supplies.all? { |supply| supply.stock > 0 }
    end
  end

end
