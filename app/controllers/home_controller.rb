class HomeController < ApplicationController
  def index
    @business = current_user.business

    UserMailer.welcome(current_user).deliver_now

    @supplies = Supply.where(business_id: @business.id)
    @low_stock_supplies = @supplies.select { |supply| supply.stock <= (supply.requires + 1) }
  end
end
