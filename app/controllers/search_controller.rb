class SearchController < ApplicationController
    def index
      query = params[:query].downcase
      @orders = Order.where("LOWER(name) LIKE ?", "%#{query}%")
      @products = Product.where("LOWER(name) LIKE ?", "%#{query}%")
      @supplies = Supply.where("LOWER(name) LIKE ?", "%#{query}%")
  
      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end
  end
  