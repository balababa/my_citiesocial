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
    product = Product.friendly.find(params[:id])
    
    if product
      cart = Cart.from_hash(session[:cart_9527])
      cart.add_item(product.code, params[:quantity])

      session[:cart_9527] = cart.to_hash

      render json: {status: 'ok', items: cart.items.count }
    end
  end
end
