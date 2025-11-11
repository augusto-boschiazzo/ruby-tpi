class CreateSales < ActiveRecord::Migration[8.1]
  def change
    create_table :sales do |t|
      t.datetime :sold_at
      t.decimal :total_amount
      t.references :client, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
