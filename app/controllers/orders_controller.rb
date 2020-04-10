class OrdersController < ApplicationController
  before_action :authenticate_user!

  def create
    @order = current_user.orders.build(order_params)
    
    current_cart.items.each do |item|
      @order.order_items.build(sku_id: item.sku_id, quantity: item.quantity)
    end

    if @order.save 
      nonce = SecureRandom.uuid
      uri = "/v3/payments/request"

      body = {
        amount: current_cart.total_price.to_i,
        currency: 'TWD',
        orderId: @order.num,
        packages: [
          {
            id: @order.num,
            amount: current_cart.total_price.to_i,
            name: 'my_citiesocial',
            products: products_hash
          }
        ],
        redirectUrls: {
          confirmUrl: "http://localhost:5000/orders/confirm",
          cancelUrl: 'http://localhost:5000/orders/cancel'
        }
      }.to_json
 

      resp = Faraday.post("#{ENV['line_pay_endpoint']}#{uri}") do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['X-LINE-ChannelId'] = ENV['line_channel_id']
        req.headers['X-LINE-Authorization-Nonce'] = nonce
        req.headers['X-LINE-Authorization'] = hmac(ENV['line_channel_secret_key'], uri, body, nonce)

        req.body = body
      end
      
      result = JSON.parse(resp.body)
  

      
      if result["returnCode"] == "0000"
        payment_url = result["info"]["paymentUrl"]["web"]
        redirect_to payment_url
      else
        flash[:notice] = "付款失敗"
        render 'carts/checkout'
      end
    else
      render 'carts/checkout'
    end
  end



  def confirm
    nonce = SecureRandom.uuid
    uri = "/v3/payments/#{params[:transactionId]}/confirm"
    body = {
      amount: current_cart.total_price.to_i, 
      currency: "TWD"
    }.to_json

    resp = Faraday.post("#{ENV['line_pay_endpoint']}#{uri}") do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['X-LINE-ChannelId'] = ENV['line_channel_id']
      req.headers['X-LINE-Authorization-Nonce'] = nonce
      req.headers['X-LINE-Authorization'] = hmac(ENV['line_channel_secret_key'], uri, body, nonce)

      req.body = body
    end

    result = JSON.parse(resp.body)
    puts "-------------"

    puts result
    puts "-------------"
    if result["returnCode"] == "0000"
      order_id = result["info"]["orderId"]
      transaction_id = result["info"]["transactionId"]
      
      # 變更order狀態
      order = current_user.orders.find_by(num: order_id)
      order.pay!(transaction_id: transaction_id)

      # 清空購物車
      session[:cart_9527] = nil

      redirect_to root_path, notice: "付款已完成"
    else
      redirect_to root_path, notice: "付款失敗"
    end
  end


  private
  def order_params
    params.require(:order).permit(:recipient, :tel, :address, :note)
  end

  def products_hash
    current_cart.items.map do |item|
      { 
        name: item.product.name + " - " + item.sku.spec,
        quantity: item.quantity,
        price: item.total_price.to_i
      }
    end
  end

  def hmac(secret, uri, req_body, nonce)
    data = secret + uri + req_body + nonce
    Base64.encode64(OpenSSL::HMAC.digest("SHA256", secret, data)).strip()
  end
end
