class Product < ApplicationRecord
  has_many :brand_products,  dependent: :destroy
  has_many :brands, through: :brand_products
  validates_uniqueness_of :name
end
