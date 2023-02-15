class Brand < ApplicationRecord
  has_many :brand_products
  has_many :products, through: :brand_products
  validates_uniqueness_of :name, :key
end
