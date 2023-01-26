class Order < ApplicationRecord
  belongs_to :user  
  has_many :products, through: :product_orders
  has_many :product_orders, dependent: :destroy
end
