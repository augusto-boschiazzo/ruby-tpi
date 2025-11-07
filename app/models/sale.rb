class Sale < ApplicationRecord
  # belongs_to :employee, class_name: "User" # Descomentar cuando tengas el modelo User
  has_many :item_sales, dependent: :destroy
  has_many :products, through: :item_sales

  accepts_nested_attributes_for :item_sales, allow_destroy: true

  validates :sold_at, :total_amount, presence: true

  def self.create_with_stock!(params, employee)
    sale = new(params)
    sale.employee = employee

    transaction do
      sale.item_sales.each do |item|
        product = item.product
        new_stock = product.stock - item.quantity
        raise ActiveRecord::Rollback, "Sin stock suficiente para #{product.name}" if new_stock < 0
        product.update!(stock: new_stock)
      end

      sale.save!
    end

    sale
  end

  def restore_stock!
    item_sales.each do |item|
      item.product.increment!(:stock, item.quantity)
    end
  end
end
