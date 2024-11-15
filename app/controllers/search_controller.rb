class SearchController < ApplicationController
    def index
      query = params[:query].downcase
      business = current_user.business
      @orders = business.orders.where("LOWER(name) LIKE ?", "%#{query}%")
      @products = business.products.where("LOWER(name) LIKE ?", "%#{query}%")
      @supplies = business.supplies.where("LOWER(name) LIKE ?", "%#{query}%")
  
      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end
  end
  
