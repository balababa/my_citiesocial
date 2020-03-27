class Product < ApplicationRecord
  include CodeGenerator
  acts_as_paranoid

  validates :code, uniqueness: true
  validates :name, presence: true
  validates :list_price, :sell_price, numericality: { greater_than: 0, allow_nil: true  }

  belongs_to :vendor
  
 
end
