class Product < ApplicationRecord
  belongs_to :brand
  validates :stock, presence: true
  validates_uniqueness_of :name
  validates :price, presence: true
end
