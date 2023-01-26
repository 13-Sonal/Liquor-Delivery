class CreateBrandProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :brand_products do |t|
			t.references :brand
			t.references :product

      t.timestamps
    end
  end
end
