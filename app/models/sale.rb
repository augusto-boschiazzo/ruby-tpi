class Sale < ApplicationRecord
  belongs_to :client
  belongs_to :user

  has_many :item_sales, dependent: :destroy
  has_many :products, through: :item_sales

  before_validation :prepare_sale
  accepts_nested_attributes_for :client
  accepts_nested_attributes_for :item_sales, allow_destroy: true

  validates :sold_at, :total_amount, presence: true
  validate :must_have_items, on: :create

  after_create :discount_stock!

  scope :active, -> { where(cancelled_at: nil) }
  scope :with_details, -> { includes(:client, item_sales: :product) }

  def self.prepare_new
    sale = new
    sale.build_client
    sale.item_sales.build
    sale
  end

  def self.build_with_client(params, user)
    client_attrs = params[:client_attributes]
    dni = client_attrs[:dni]
    client = Client.find_by(dni: dni)

    sale = if client
             new(params.except(:client_attributes).merge(client: client))
    else
             new(params)
    end
    sale.user = user
    sale
  end

  def prepare_associations
    build_client unless client
    item_sales.build if item_sales.empty?
  end

  def must_have_items
    errors.add(:base, :must_have_items) if item_sales.empty?
  end

  def cancel!
    return if cancelled_at.present?

    ActiveRecord::Base.transaction do
      update!(cancelled_at: Time.current)
      restore_stock!
    end
  end

  private

  def prepare_sale
    self.sold_at ||= Time.current
    self.total_amount = item_sales.sum { |item| item.unit_price.to_f * item.quantity.to_i }
  end

  def adjust_stock!(sign)
    item_sales.each do |item|
      product = item.product
      new_stock = product.stock + sign * item.quantity
      if new_stock < 0
        raise ActiveRecord::Rollback,
              I18n.t("activerecord.errors.models.sale.attributes.base.not_enough_stock",
                     product: product.name)
      end
      product.update!(stock: new_stock)
    end
  end

  def restore_stock!
    adjust_stock!(+1)
  end

  def discount_stock!
    ActiveRecord::Base.transaction { adjust_stock!(-1) }
  end
end
