class Product < ApplicationRecord
  belongs_to :brands
	has_many :user, through: :orders
  has_many :orders, dependent: :destroy
end
