class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id])
  end
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
    @business = current_user.business
    @product = Product.find(params[:id])
    @supplies = Supply.all
  end
  
  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      # Actualizar la supply list
      @product.supply_list.supplies.clear # Limpiar los insumos actuales
      supply_names = params[:supply_name]
      supply_names.each do |name|
        supply = Supply.find_by(name: name)
        @product.supply_list.supplies << supply if supply
      end
  
      redirect_to products_path, notice: 'Product was successfully updated.'
    else
      @supplies = Supply.all
      render :edit
    end
  end
  

 

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      flash[:success] = 'Object was successfully deleted.'
      redirect_to products_url
    else
      flash[:error] = 'Something went wrong'
      redirect_to products_url
    end
  end
  
  private

  def set_business
    @business = current_user.business
  end
  def product_params
    params.require(:product).permit(:name, :price)
  end

end
