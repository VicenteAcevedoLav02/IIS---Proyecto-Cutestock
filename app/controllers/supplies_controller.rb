class SuppliesController < ApplicationController
  def show
    @supply = Supply.find(params[:id])
  end
  def index
    @business = current_user.business
    @supplies = Supply.where(business_id: @business.id)
  end

  def new
    @business = current_user.business
    @next_supply_id = Supply.last&.id.to_i + 1 # O un método alternativo para obtener el próximo ID
    @supply = Supply.new
  end

  def create
    @supply = Supply.new(supply_params)
    @supply.business = current_user.business

    if @supply.save
      flash[:success] = 'Supply was successfully created.'
      redirect_to supplies_path#, notice: 'Supply was successfully created.'
    else
      flash[:error] = 'Supply could not be created.'
      render :new
    end
  end
  def edit
    @business = current_user.business
    @supply = Supply.find(params[:id])
  end

   def restock
    @supply = Supply.find(params[:id])
    restock_amount = params[:restock_amount].to_i
    if restock_amount.positive?
      @supply.update(stock: @supply.stock + restock_amount)
      flash[:notice] = "Stock of #{@supply.name} increased by #{restock_amount}."
    else
      flash[:alert] = "Invalid restock amount."
    end
    redirect_to request.referer || stock_alerts_path # Ajusta la ruta según tu configuración
  end

  def update
    @business = current_user.business
    @supply = Supply.find(params[:id])
    if @supply.update(supply_params)
      flash[:success] = 'Supply was successfully updated.'
      redirect_to supplies_path#, notice: 'Supply was successfully updated.'
    else
      flash[:error] = 'Supply could not be updated.'
      render :edit
    end
  end

  def destroy
    @supply = Supply.find(params[:id])
    if @supply.destroy
      flash[:success] = 'Supply was successfully deleted.'
      redirect_to supplies_url
    else
      flash[:error] = 'Something went wrong deleting supply'
      redirect_to supplies_url
    end
  end
  def needs_restock
    @business = current_user.business
    @supplies_needing_restock = Supply.where(business_id: @business.id).select(&:needs_restock?)
  end
  
  private

  def set_business
    @business = current_user.business
  end
  def supply_params
    params.require(:supply).permit(:name, :tipo1, :tipo2, :tipo3, :cost, :stock, :requires)
  end
end
