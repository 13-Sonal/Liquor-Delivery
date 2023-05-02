class UpdateProductOrderTable < ActiveRecord::Migration[6.1]
  def change
    add_column :product_orders, :items, :string
    add_column :product_orders, :accumulated_price, :string
    remove_column :product_orders, :status

  end
end
