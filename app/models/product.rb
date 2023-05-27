class Product < ApplicationRecord
  belongs_to :brand
  scope :active_brands, -> { joins(:brand).where("brands.is_active = ?", true) }
  validates :stock, presence: true
  validates :price, presence: true
  validates :name, presence: true

end
