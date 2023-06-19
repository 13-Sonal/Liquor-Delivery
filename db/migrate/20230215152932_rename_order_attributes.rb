class RenameOrderAttributes < ActiveRecord::Migration[6.1]
  def change
    rename_column :orders, :order_quantity, :total_quantity
    rename_column :orders, :total_price, :bill_value
  end
end
