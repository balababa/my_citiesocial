class Cart
  attr_reader :items
  def initialize()
    @items = []
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

end