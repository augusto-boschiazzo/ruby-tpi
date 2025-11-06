class AddUnitPriceToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :unit_price, :decimal
  end
end
