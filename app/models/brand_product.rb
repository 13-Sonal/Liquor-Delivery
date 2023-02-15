class BrandProduct < ApplicationRecord
  belongs_to :brand
  belongs_to :product
  validates :price, :quantity, presence: true
end
