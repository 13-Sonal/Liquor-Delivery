class AddFalgToBrand < ActiveRecord::Migration[6.1]
  def change
    add_column :brands, :is_active, :boolean, default: "true", null: false 
  end
end
