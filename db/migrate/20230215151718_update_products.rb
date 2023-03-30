class UpdateProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :stock, :string
    add_column :products, :price, :string
    add_reference :products, :brand, foreign_key: true

  end
end
