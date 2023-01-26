class Brand < ApplicationRecord
  has_many :products, through: :brand_products
  has_many :brand_products
end
