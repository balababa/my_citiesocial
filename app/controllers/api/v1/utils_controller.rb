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

  def change_item_num
    offset = params["offset"].to_i
    sku_id = params["sku_id"]
    cart_item = current_cart.items.find {|item| item.sku_id == sku_id}

    if cart_item
      result = cart_item.increment!(offset)
      session[:cart_9527] = current_cart.to_hash

      render json: {num:  result, sum: cart_item.total_price, total: current_cart.total_price }
    else
      render json: {status: "cannot find cart_item"}
    end

  end
end
