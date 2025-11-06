class CreateSales < ActiveRecord::Migration[8.1]
  def change
    create_table :sales do |t|
      t.datetime :sold_at
      t.decimal :total_amount
      t.references :employee, null: false, foreign_key: true
      t.string :customer_name
      t.datetime :cancelled_at

      t.timestamps
    end
  end
end
