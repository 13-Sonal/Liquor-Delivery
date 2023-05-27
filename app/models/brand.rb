class Brand < ApplicationRecord
  scope :active, -> { where(:is_active => true) }
  has_many :products
  validates_uniqueness_of :name
 
end
