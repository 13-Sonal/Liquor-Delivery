class CreateProductOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :product_orders do |t|
      t.references :order
      t.references :product
      t.string :status

      t.timestamps
    end
  end
end
