class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :user
      t.references :product
      t.integer :order_quantity
      t.integer :bill_value
      
      
      t.timestamps
    end
  end
end
