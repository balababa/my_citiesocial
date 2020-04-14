class ProductsController < ApplicationController

  def index
    @products = Product.on_sell.includes(:vendor)
  end

  def show
    @product = Product.on_sell.friendly.find(params[:id])
  end

  def search
    keyword = params[:keyword]
    @products = Product.on_sell.where('name ~ ?', "\d*(#{keyword}|#{keyword.swapcase})\d*")
  end
end
