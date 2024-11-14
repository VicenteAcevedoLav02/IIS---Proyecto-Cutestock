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
      redirect_to supplies_path, notice: 'Supply was successfully created.'
    else
      render :new
    end
  end
  def edit
    @business = current_user.business
    @supply = Supply.find(params[:id])
  end

  def update
    @business = current_user.business
    @supply = Supply.find(params[:id])
    if @supply.update(supply_params)
      redirect_to supplies_path, notice: 'Supply was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @supply = Supply.find(params[:id])
    if @supply.destroy
      flash[:success] = 'Object was successfully deleted.'
      redirect_to supplies_url
    else
      flash[:error] = 'Something went wrong'
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
