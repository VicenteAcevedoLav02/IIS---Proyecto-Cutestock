class ProductsController < ApplicationController
  def index
    @business = current_user.business
    @products = Product.where(business_id: @business.id)
    
    # Utilizando un join para relacionar Product y SupplyList
    @supply_lists = SupplyList.joins(:product)
                              .where(products: { business_id: @business.id })

  
  end

  def new
    @business = current_user.business
    @next_order_id = Order.last&.id.to_i + 1 # O un método alternativo para obtener el próximo ID
    @product = Product.new
    @supplies = Supply.all # Obtén todos los supplies disponibles
  end

  def create
    @product = Product.new(product_params)
    @product.business = current_user.business

    if @product.save
      # Crear SupplyList para el producto
      supply_list = SupplyList.create(product: @product)

      # Agregar los supplies seleccionados a la supply list
      supply_names = params[:supply_name]
      supply_names.each do |name|
        supply = Supply.find_by(name: name)
        supply_list.supplies << supply if supply
      end

      redirect_to products_path, notice: 'Product was successfully created.'
    else
      @supplies = Supply.all
      render :new
    end
  end

  def edit
  end

  def show
  end
  private

  def set_business
    @business = current_user.business
  end
  def product_params
    params.require(:product).permit(:name, :price)
  end

end
