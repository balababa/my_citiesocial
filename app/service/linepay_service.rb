class LinepayService
  def initialize(cart:nil, type:"request", order:nil)
    @cart = cart
    @type = type
    @order = order
  end

  def perform(transaction_id = nil)
    uri = case @type
          when 'request', 'pay'
            body = body_request 
            "/v3/payments/request"
          when 'confirm', 'pay_confirm'
            body = body_confirm 
            "/v3/payments/#{transaction_id}/confirm"
          when 'cancel'
            body = {}.to_json
            "/v3/payments/#{transaction_id}/refund"
          end
    nonce = SecureRandom.uuid
    resp = Faraday.post("#{ENV['line_pay_endpoint']}#{uri}") do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['X-LINE-ChannelId'] = ENV['line_channel_id']
      req.headers['X-LINE-Authorization-Nonce'] = nonce
      req.headers['X-LINE-Authorization'] = hmac(ENV['line_channel_secret_key'], uri, body, nonce)

      req.body = body
    end
    
    @result = JSON.parse(resp.body)
  end

  def hmac(secret, uri, req_body, nonce)
    data = secret + uri + req_body + nonce
    Base64.encode64(OpenSSL::HMAC.digest("SHA256", secret, data)).strip()
  end

  def body_request
    if @type == 'request'
      uri = "#{ENV['local']}/orders/confirm"
    else
      uri = "#{ENV['local']}/orders/#{@order.id}/pay_confirm"
    end
    
    {
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
        confirmUrl: uri,
        cancelUrl: "#{ENV['local']}/orders/cancel"
      }
    }.to_json
  end

  def body_confirm
    amount =  @type == 'pay_confirm' ? @order.total_price : @cart.total_price.to_i
    {
      amount: amount, 
      currency: "TWD"
    }.to_json
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

  def success?
    @result['returnCode'] == '0000'
  end
end