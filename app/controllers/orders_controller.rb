class OrdersController < ApplicationController
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
    @business = current_user.business
    product_names = params[:product_name]
    quantities = params[:quantity].map(&:to_i)
    
    products = Product.where(name: product_names)
    total_price = products.each_with_index.sum { |product, index| product.price * quantities[index] }
    
    @order = Order.new(order_params)
    @order.business = @business
    @order.price = total_price
    @order.production_cost = 1 # Default value
    @order.net_profit = 1 # Default value

    if @order.save
      product_list = ProductList.create(order: @order)
      product_names.each_with_index do |name, index|
        product = products.find { |p| p.name == name }
        product_list.products << product if product && quantities[index] > 0
      end
      
      redirect_to orders_path, notice: "Order created successfully."
    else
      render :new
    end
  end

  def show
  end
  private

  def set_business
    @business = current_user.business
  end
  def order_params
    params.require(:order).permit(:name)
  end
end
