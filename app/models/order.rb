class Order < ApplicationRecord
  belongs_to :users
  belongs_to :products

end
