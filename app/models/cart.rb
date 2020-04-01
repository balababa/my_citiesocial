class Cart
  attr_reader :items
  def initialize( items = [])
    @items = items
  end


  def add_item(product_id, quantity = 1)
    found = items.find {|item| item.product_id == product_id}
    if found
      found.increment!(quantity)
    else
      items << CartItem.new(product_id, quantity)
    end
  end

  def empty?
    @items.empty?
  end

  def total_price
    # items.map {|item| item.total_price}.sum
    # items.map {|item| item.total_price}.reduce(:+)
    total = items.reduce(0) { |sum, item| sum += item.total_price }
    (Date.today.day == 25 && Date.today.month == 12) ? total * 0.9 : total
  end

  def to_hash
    items = @items.map { |item| {"product_id" => item.product_id, 
                                "quantity" => item.quantity} }
    
    {
      "items" => items
    }
  end

  def self.from_hash(hash = nil)
    items = []
    
    if hash && hash["items"]
      items = hash["items"].map { |item|
        CartItem.new(item["product_id"], item["quantity"])
      }
    end
    
    Cart.new(items)
  end

end