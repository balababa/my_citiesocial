class OrdersController < ApplicationController
  before_action :authenticate_user!

  def create
    @order = current_user.orders.build(order_params)
    
    current_cart.items.each do |item|
      @order.order_items.build(sku_id: item.sku_id, quantity: item.quantity)
    end

    if @order.save 

      resp = Faraday.post("#{ENV['line_pay_endpoint']}/v2/payments/request") do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['X-LINE-ChannelId'] = ENV['line_channel_id']
        req.headers['X-LINE-ChannelSecret'] = ENV['line_channel_secret_key']
        req.body = {
          productName: 'salmon', 
          amount: current_cart.total_price.to_i, 
          currency: "TWD", 
          confirmUrl: "http://localhost:3000/orders/confirm", 
          orderId:  @order.num
        }.to_json
      end
      console.log(resp.headers)
      redirect_to root_path, notice: "ok"
    else
      render 'carts/checkout'
    end
  end

  private
  def order_params
    params.require(:order).permit(:recipient, :tel, :address, :note)
  end
end
