class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.integer :quantity
      t.string :prod_name
      t.float :price
      t.references :brand

      t.timestamps
    end
  end
end
