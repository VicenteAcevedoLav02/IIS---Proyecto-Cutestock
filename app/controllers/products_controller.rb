class ProductsController < ApplicationController
  def index
    @business = current_user.business
    @products = Product.where(business_id: @business.id)
    
    # Utilizando un join para relacionar Product y SupplyList
    @supply_lists = SupplyList.joins(:product)
                              .where(products: { business_id: @business.id })
  
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
