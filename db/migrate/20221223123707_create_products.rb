class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.integer :quantity
      t.string :name
      t.float :price

      t.timestamps
    end
  end
end
