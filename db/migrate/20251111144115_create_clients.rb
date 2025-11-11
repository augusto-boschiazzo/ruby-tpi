class CreateClients < ActiveRecord::Migration[8.1]
  def change
    create_table :clients do |t|
      t.string :dni
      t.string :name

      t.timestamps
    end

    add_index :clients, :dni, unique: true
  end
end
