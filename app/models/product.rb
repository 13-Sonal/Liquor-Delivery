class Product < ApplicationRecord
  belongs_to :brand
  scope :active_brands, -> { joins(:brand).where("brands.is_active = ?", true) }
  validates :stock, :price, :name, presence: true
end
