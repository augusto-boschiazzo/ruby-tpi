class Sale < ApplicationRecord
  # belongs_to :employee, class_name: "User" # Descomentar cuando tengas el modelo User
  belongs_to :client
  has_many :item_sales, dependent: :destroy
  has_many :products, through: :item_sales

  accepts_nested_attributes_for :item_sales, allow_destroy: true

  validates :sold_at, :total_amount, presence: true
  validate :must_have_at_least_one_item
  validate :validate_stock_levels

  def self.create_with_stock!(params, employee)
    dni = params.delete(:client_dni)
    name = params.delete(:client_name)

    client = Client.find_or_initialize_by(dni: dni)
    client.name = name if client.new_record?
    client.save!

    sale = new(params)
    sale.employee = employee
    sale.client = client
    sale.sold_at = Time.current

    unless sale.valid?
      raise ActiveRecord::Rollback, sale.errors.full_messages.join(", ")
    end

    transaction do
      total = 0
      sale.item_sales.each do |item|
        product = item.product
        new_stock = product.stock - item.quantity
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

  def must_have_at_least_one_item
    if item_sales.reject(&:marked_for_destruction?).empty?
      errors.add(:base, "La venta debe tener al menos un producto.")
    end
  end

  def validate_stock_levels
    item_sales.each do |item|
      next if item.marked_for_destruction? || item.product.nil?

      if item.product.stock < item.quantity
        errors.add(:base, "No hay stock suficiente para #{item.product.name}")
      end
    end
  end

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
