class AddQtyPriceToBrandProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :brand_products, :price, :string
    add_column :brand_products, :quantity, :string
  end
end
