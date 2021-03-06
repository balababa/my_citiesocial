class Product < ApplicationRecord
  include CodeGenerator
  acts_as_paranoid
  has_rich_text :description
  has_one_attached :cover_image
  scope :on_sell, -> { where( on_sell: true).order(updated_at: :desc) }
  scope :search, ->(keyword) {
    key = keyword.split('').map {|c| "[#{c}#{c.swapcase}]"}.join
    reg = "\d*#{key}\d*"
    where('name ~ ?', reg)
  }

  validates :code, uniqueness: true
  validates :name, presence: true
  validates :list_price, :sell_price, numericality: { greater_than: 0, allow_nil: true  }

  belongs_to :vendor
  belongs_to :category, optional: true
  has_many :skus
  accepts_nested_attributes_for :skus, reject_if: :all_blank, allow_destroy: true
 
end
