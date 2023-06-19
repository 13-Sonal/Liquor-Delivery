class Brand < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :products
  scope :active, -> { where(:is_active => true) }
end
