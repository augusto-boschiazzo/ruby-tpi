class ItemSale < ApplicationRecord
  belongs_to :sale
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }
  validate :product_has_enough_stock

  def product_has_enough_stock
    return if product.nil? || quantity.nil?

    if quantity > product.stock
      errors.add(:quantity, "no puede superar el stock disponible (#{product.stock})")
    end
  end
end
