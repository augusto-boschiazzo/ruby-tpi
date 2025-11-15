class Sale < ApplicationRecord
  belongs_to :client
  belongs_to :user

  has_many :item_sales, dependent: :destroy
  has_many :products, through: :item_sales

  before_validation :calculate_total_amount
  before_validation :set_sold_at, on: :create

  accepts_nested_attributes_for :client
  accepts_nested_attributes_for :item_sales, allow_destroy: true
  validates_associated :item_sales
  validates :sold_at, :total_amount, presence: true
  validate :must_have_items

  after_create :discount_stock!

  scope :active, -> { where(cancelled_at: nil) }

  # Validar que la venta tenga almenos un item
  def must_have_items
    if item_sales.empty?
      errors.add(:base, "La venta debe tener al menos un producto")
    end
  end

  def cancel!
    return if cancelled_at.present?

    ActiveRecord::Base.transaction do
      update!(cancelled_at: Time.current)
      restore_stock!
    end
  end

  private

  def set_sold_at
    self.sold_at ||= Time.current
  end

  def calculate_total_amount
    self.total_amount = item_sales.map { |item| item.unit_price.to_f * item.quantity.to_i }.sum
  end

  def restore_stock!
    item_sales.each do |item|
      product = item.product
      product.update!(stock: product.stock + item.quantity)
    end
  end

  def discount_stock!
    ActiveRecord::Base.transaction do
      item_sales.each do |item|
        product = item.product
        new_stock = product.stock - item.quantity

        if new_stock < 0
          raise ActiveRecord::Rollback, "No hay suficiente stock para #{product.name}"
        end

        product.update!(stock: new_stock)
      end
    end
  end
end
