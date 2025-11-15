class AddCancelledAtToSales < ActiveRecord::Migration[8.1]
  def change
    add_column :sales, :cancelled_at, :datetime
  end
end
