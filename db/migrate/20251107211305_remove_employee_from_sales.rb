class RemoveEmployeeFromSales < ActiveRecord::Migration[8.1]
  def change
    remove_reference :sales, :employee, null: false, foreign_key: true
  end
end
