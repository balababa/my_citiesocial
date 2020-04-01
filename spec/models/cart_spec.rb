require 'rails_helper'
require 'faker'

RSpec.describe Cart, type: :model do
  describe "基本功能" do
    it "可以把商品丟到到購物車裡，然後購物車裡就有東西了" do
      cart = Cart.new

      cart.add_item(1)
      
      expect(cart.empty?).to be false
    end
    
    it "如果加了相同種類的商品到購物車裡，購買項目（CartItem）並不會增加，但商品的數量會改變" do
      cart = Cart.new

      3.times { cart.add_item(1) }
      2.times { cart.add_item(2) }
      cart.add_item(3)

      expect(cart.items.count).to be 3
      expect(cart.items.first.quantity).to be 3
    end
    
    it "商品可以放到購物車裡，也可以再拿出來" do
      cart = Cart.new
      p1 = FactoryBot.create(:product)
      
      cart.add_item(p1.id)

      expect(cart.items.first.product).to be_a Product
    end


    it "可以計算整台購物車的總消費金額" do
      cart = Cart.new
      p1 = FactoryBot.create(:product, sell_price: 5)
      p2 = FactoryBot.create(:product, sell_price: 10)
  
      3.times { cart.add_item(p1.id) }
      2.times { cart.add_item(p2.id) }

      expect(cart.total_price).to eq 35
    end

    it "特別活動可搭配折扣（例如聖誕節的時候全面打 9 折，或是滿額滿千送百或滿額免運費）" do
      cart = Cart.new
      p1 = FactoryBot.create(:product, sell_price: 10)
      p2 = FactoryBot.create(:product, sell_price: 10)
  
      3.times { cart.add_item(p1.id) }
      2.times { cart.add_item(p2.id) }

      expect(cart.total_price).to eq 50
      Timecop.freeze(DateTime.new(2020, 12, 25)) do
        expect(cart.total_price).to eq 45
      end
  end
  end

  describe "進階功能" do
  end
end
