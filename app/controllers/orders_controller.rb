class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_order, only:[:show, :pay, :pay_confirm, :cancel]
  include Pagy::Backend

  def index
    # @orders = current_user.orders.order(id: :desc)
    @pagy, @orders= pagy(current_user.orders.order(id: :desc),  items: 20)
  end

  def show
  end

  def create
    @order = current_user.orders.build(order_params)
    
    current_cart.items.each do |item|
      @order.order_items.build(sku_id: item.sku_id, quantity: item.quantity) unless item.quantity.zero?
    end

    

    if (not @order.order_items.empty?) && @order.save 
      service = LinepayService.new(type: 'request', order: @order)
      result = service.perform()
      
      if service.success?
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
    service = LinepayService.new(cart: current_cart, type: 'confirm')
    result = service.perform(params[:transactionId])

    if service.success?
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
 
      service = LinepayService.new(type: 'cancel')
      result = service.perform( @order.transaction_id)

      if service.success?
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
      service = LinepayService.new(type: 'pay', order: @order)
      result = service.perform()

      if service.success?
        payment_url = result["info"]["paymentUrl"]["web"]
        redirect_to payment_url
      else

        redirect_to orders_path, notice: "付款發生錯誤"
      end
  end

  def pay_confirm

    service = LinepayService.new(type: 'pay_confirm', order: @order)
    result = service.perform(params[:transactionId]) 

    if service.success?
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

end
