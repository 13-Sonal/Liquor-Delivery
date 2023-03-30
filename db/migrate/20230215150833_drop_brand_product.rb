class DropBrandProduct < ActiveRecord::Migration[6.1]
  def change
    drop_table :brand_products
  end
end
