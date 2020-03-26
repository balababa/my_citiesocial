class Vendor < ApplicationRecord
  acts_as_paranoid
  validates :title, presence: true

  scope :available, -> { where(online: true) }
  # def self.available
  #   self.where(online: true)
  # end
  
end
