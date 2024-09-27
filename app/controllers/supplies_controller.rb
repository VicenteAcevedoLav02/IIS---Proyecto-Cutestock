class SuppliesController < ApplicationController
  def index
    @business = current_user.business
    @supplies = Supply.where(business_id: @business.id)
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
