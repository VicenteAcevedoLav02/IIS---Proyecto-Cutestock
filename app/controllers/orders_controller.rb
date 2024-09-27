class OrdersController < ApplicationController
  def index
    @business = current_user.business
    puts current_user.inspect
    @orders = Order.where(business_id: @business.id)
    @product_lists = ProductList.joins(:order)
    .where(orders: { business_id: @business.id })
puts("PRODUCT LIST:")
puts @product_lists.inspect  # This will print the details of the filtered product_lists
  end

  def new
  end

  def edit
  end

  def show
  end
  private

  def set_business
    @business = current_user.business
  

  end
end
