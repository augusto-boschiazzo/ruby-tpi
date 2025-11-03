class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.string :author
      t.decimal :price
      t.integer :stock
      t.integer :product_type
      t.references :product_category, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
