class Product < ApplicationRecord
  include CodeGenerator
  acts_as_paranoid
  has_rich_text :description


  validates :code, uniqueness: true
  validates :name, presence: true
  validates :list_price, :sell_price, numericality: { greater_than: 0, allow_nil: true  }

  belongs_to :vendor
  
 
end
