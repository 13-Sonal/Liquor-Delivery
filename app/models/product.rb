class Product < ApplicationRecord
  has_many :brands, through: :brand_products
  has_many :brand_products,  dependent: :destroy
end
