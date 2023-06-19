class ProductOrder < ApplicationRecord
  belongs_to :product
  belongs_to :order

  after_create :update_quantity

  def update_quantity
    # callback to update the quantity of stock after every order of items
    # Find product, update the stock by reducing items
    product.update(stock: (product.stock.to_i - items.to_i))
  end
end
