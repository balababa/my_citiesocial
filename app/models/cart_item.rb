class CartItem
  attr_reader :quantity, :sku_id
  def initialize(sku_id, quantity = 1)
    @sku_id = sku_id
    @quantity = quantity
  end

  def increment!(n = 1)
    @quantity += n
  end

  def product
    # Product.friendly.find(sku_id)
    Product.joins(:skus).find_by(skus: {id: sku_id})
  end

  def sku
    Sku.find(sku_id)
  end

  def total_price
    product.sell_price * quantity
  end
end