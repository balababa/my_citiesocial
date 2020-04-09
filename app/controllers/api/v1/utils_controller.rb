class Api::V1::UtilsController < ApplicationController
  def subscribe
    email =  params['subscribe']['email']
    
    sub = Subscribe.new(email: email)

    if sub.save
      UserSubscribeEmailJob.perform_later(email)
      render json: {status: 'ok', email: email}
    else
      if email.empty?
        render json: {status: 'blank'}
        
      else
        render json: {status: 'duplicated', email: 'email'}
      end
    end

  end

  def cart
    # product = Product.friendly.find(params[:id])
    product = Product.joins(:skus).find_by(skus: { id: params[:sku]})
    
    if product 
      current_cart.add_sku(params[:sku], params[:quantity].to_i)

      session[:cart_9527] = current_cart.to_hash

      render json: {status: 'ok', items: current_cart.items.count }
    end
  end
end
