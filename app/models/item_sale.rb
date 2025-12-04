class ItemSale < ApplicationRecord
  belongs_to :sale
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }
  validate :product_has_enough_stock

  before_validation :set_unit_price_from_product, if: -> { product.present? && unit_price.blank? }

  def product_has_enough_stock
    return if product.nil? || quantity.nil? || product.stock.nil?

    if quantity > product.stock
      errors.add(:quantity, "no puede superar el stock disponible (#{product.stock})")
    end
  end

  def set_unit_price_from_product
    self.unit_price = product.price
  end
end
