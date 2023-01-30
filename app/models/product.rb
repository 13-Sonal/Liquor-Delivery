class Product < ApplicationRecord
  has_many :brands, through: :brand_products
  has_many :brand_products,  dependent: :destroy
  validates_uniqueness_of :name
end
