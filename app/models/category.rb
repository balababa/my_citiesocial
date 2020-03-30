class Category < ApplicationRecord
  default_scope { order(position: :asc) }

  acts_as_paranoid
  acts_as_list
  
  has_many :products

  validates :name, presence: true
end
