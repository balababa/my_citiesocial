class ProductsController < ApplicationController

  def index
    @products = Product.order(updated_at: :desc).includes(:vendor)
  end

  def show
    @product = Product.friendly.find(params[:id])
  end

  def search
    keyword = params[:keyword]
    @products = Product.where('name ~ ?', "\d*#{keyword}\d*")
  end
end
