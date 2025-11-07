class Sale < ApplicationRecord
  # belongs_to :employee, class_name: "User" # Descomentar cuando tengas el modelo User
  has_many :item_sales, dependent: :destroy
  has_many :products, through: :item_sales

  accepts_nested_attributes_for :item_sales, allow_destroy: true

  validates :sold_at, :total_amount, presence: true

  def self.create_with_stock!(params, employee)
    sale = new(params)
    sale.employee = employee
    sale.sold_at = Time.current

    transaction do
      total = 0
      sale.item_sales.each do |item|
        product = item.product
        new_stock = product.stock - item.quantity
        # raise ActiveRecord::Rollback, "Sin stock suficiente para #{product.name}" if new_stock < 0
        product.update!(stock: new_stock)
        total += item.unit_price * item.quantity
      end

      sale.total_amount = total
      sale.save!
    end

    sale
  end

  after_update :restore_stock_if_cancelled

  private

  def restore_stock_if_cancelled
    if saved_change_to_cancelled_at? && cancelled_at.present?
      restore_stock!
    end
  end

  def restore_stock!
    item_sales.each do |item|
      item.product.increment!(:stock, item.quantity)
    end
  end
end
