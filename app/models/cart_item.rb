class CartItem
  attr_reader :quantity, :product_id
  def initialize(product_id, quantity = 1)
    @product_id = product_id
    @quantity = quantity
  end

  def increment!(n = 1)
    @quantity += n
  end

  def product
    Product.friendly.find(product_id)
  end

  def total_price
    product.sell_price * quantity
  end
end