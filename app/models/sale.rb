class Sale < ApplicationRecord
  # belongs_to :employee, class_name: "User" #Lo comento hasta que se cree User
  has_many :item_sales, dependent: :destroy
  has_many :products, through: :item_sales

  accepts_nested_attributes_for :item_sales, allow_destroy: true

  validates :sold_at, :total_amount, presence: true
end
