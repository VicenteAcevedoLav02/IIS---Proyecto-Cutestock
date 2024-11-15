class OrdersController < ApplicationController

  def show
    @order = Order.find(params[:id])
  end


  def index
    @business = current_user.business
    puts current_user.inspect
    @orders = Order.where(business_id: @business.id)
                   .sort_by { |order| custom_order(order.state) }
    @product_lists = ProductList.joins(:order).where(orders: { business_id: @business.id })
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
      flash[:success] = 'Order was created succesfuly.'
      redirect_to orders_path
    else
      flash[:error] = 'Order could not be created.'
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
      flash[:success] = 'Order updated succesfuly.'
      redirect_to orders_path
    else
      flash[:error] = 'Order could not be updated.'
      render :edit
    end
  end

  def progress_state
    @order = Order.find(params[:id])
    
    # Guarda el estado anterior antes de actualizar
    previous_state = @order.state

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
            supply.update(stock: supply.stock - supply.requires) if supply.stock > 0
          end
        end

        @order.update(state: 'Completed')
        
        # mandar mail!!
        OrderMailer.state_changed(
          @order, 
          previous_state, 
          current_user.email
        ).deliver_later
        flash[:info] = 'Order State updated to Completed; Email sent and Supplies Updated.'
        redirect_to orders_path#, notice: 'Estado de Orden actualizado a Completado; envio de mail hecho. Supplies actualizadas.'
      else
        flash[:info] = 'There is not enough stock to complete this order.'
        redirect_to orders_path#, notice: 'No hay suficiente stock para completar la orden.'
      end
    else
      flash[:info] = 'Order state can not be changed.'
      redirect_to orders_path#, notice: 'Order state no puede ser cambiada.'
    end
  end

  
  def destroy
    @order = Order.find(params[:id])
    if @order.destroy
      flash[:success] = 'The order was removed succesfuly.'
      redirect_to orders_url
    else
      flash[:error] = 'The order could not be removed.'
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

  def custom_order(state)
    case state
      when 'Pending'
        0
      when 'In Progress'
        1
      when 'Completed'
        2
      else
        3
    end
  end

end
