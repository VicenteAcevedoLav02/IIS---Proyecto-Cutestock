class HomeController < ApplicationController
  def index
    @business = current_user.business
    @supplies = Supply.where(business_id: @business.id)
    @low_stock_supplies = @supplies.select { |supply| supply.stock <= (supply.requires + 1) }
  end
end
