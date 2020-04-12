class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_order, only:[:pay, :pay_confirm, :cancel]

  def index
    @orders = current_user.orders.order(id: :desc)
  end

  def create
    @order = current_user.orders.build(order_params)
    
    current_cart.items.each do |item|
      @order.order_items.build(sku_id: item.sku_id, quantity: item.quantity)
    end

    if @order.save 

      body = {
        amount: @order.total_price.to_i,
        currency: 'TWD',
        orderId: @order.num,
        packages: [
          {
            id: @order.num,
            amount: @order.total_price.to_i,
            name: 'my_citiesocial',
            products: products_hash(@order)
          }
        ],
        redirectUrls: {
          confirmUrl: "http://localhost:5000/orders/confirm",
          cancelUrl: 'http://localhost:5000/orders/cancel'
        }
      }.to_json

      result = faraday_post(body, "/v3/payments/request")  

      
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
    body = {
      amount: current_cart.total_price.to_i, 
      currency: "TWD"
    }.to_json

    result = faraday_post(body, "/v3/payments/#{params[:transactionId]}/confirm") 

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


  def cancel
    if @order.paid?
      body = {}.to_json

      result = faraday_post(body, "/v3/payments/#{@order.transaction_id}/refund") 
      
      if result["returnCode"] == "0000"
        @order.cancel!
        redirect_to orders_path, notice: "訂單 #{@order.num} 已取消，並完成退款"  
      else
        redirect_to orders_path, notice: "退款失敗"
      end

    else
      @order.cancel!
      redirect_to orders_path, notice: "訂單 #{@order.num} 已取消"  
    end
  end


  def pay
    body = {
        amount: @order.total_price.to_i,
        currency: 'TWD',
        orderId: @order.num,
        packages: [
          {
            id: @order.num,
            amount: @order.total_price.to_i,
            name: 'my_citiesocial',
            products: products_hash(@order)
          }
        ],
        redirectUrls: {
          confirmUrl: "http://localhost:5000/orders/#{@order.id}/pay_confirm",
          cancelUrl: 'http://localhost:5000/orders/cancel'
        }
      }.to_json
 
      result = faraday_post(body, "/v3/payments/request") 

      if result["returnCode"] == "0000"
        payment_url = result["info"]["paymentUrl"]["web"]
        redirect_to payment_url
      else
        redirect_to orders_path, notice: "付款發生錯誤"
      end
  end

  def pay_confirm
    body = {
      amount: @order.total_price, 
      currency: "TWD"
    }.to_json

    result = faraday_post(body, "/v3/payments/#{params[:transactionId]}/confirm") 

    if result["returnCode"] == "0000"
      transaction_id = result["info"]["transactionId"]
      
      # 變更order狀態
      @order.pay!(transaction_id: transaction_id)

      redirect_to orders_path, notice: "付款已完成"
    else
      redirect_to orders_path, notice: "付款失敗"
    end

  end

  private
  def find_order
    @order = current_user.orders.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:recipient, :tel, :address, :note)
  end
  
  def products_hash(order)
    order.order_items.map do |item|
      {
        name: item.sku.product.name + " - " + item.sku.spec,
        quantity: item.quantity,
        price: item.total_price.to_i
      }
    end
  end

  def faraday_post(body, uri)
    nonce = SecureRandom.uuid
    resp = Faraday.post("#{ENV['line_pay_endpoint']}#{uri}") do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['X-LINE-ChannelId'] = ENV['line_channel_id']
      req.headers['X-LINE-Authorization-Nonce'] = nonce
      req.headers['X-LINE-Authorization'] = hmac(ENV['line_channel_secret_key'], uri, body, nonce)

      req.body = body
    end
    JSON.parse(resp.body)
  end

  def hmac(secret, uri, req_body, nonce)
    data = secret + uri + req_body + nonce
    Base64.encode64(OpenSSL::HMAC.digest("SHA256", secret, data)).strip()
  end
end
