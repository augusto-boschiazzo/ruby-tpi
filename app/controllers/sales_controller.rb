class SalesController < ApplicationController
  before_action :set_sale, only: [ :show, :cancel ]

  def index
    @sales = Sale.order(sold_at: :desc)
  end

  def new
    @sale = Sale.new
    @sale.item_sales.build
  end

  def create
    @sale = Sale.new(sale_params)
    @sale.employee = current_user # Supongo que el usuario actual es el empleado que hizo la venta
    ActiveRecord::Base.transaction do
      validate_stock! # Valido si hay stock disponible del producto

      if @sale.save
        update_stock!
        redirect_to @sale, notice: "Sale successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def show
  end

  def cancel
    @sale.update(cancelled_at: Time.current)
    restore_stock!
    redirect_to sales_path, notice: "Sale cancelled and stock restored."
  end

  private

  def set_sale
    @sale = Sale.find(params[:id])
  end

  def sale_params
    params.require(:sale).permit(
      :sold_at, :total_amount, :customer_name,
      item_sales_attributes: [ :product_id, :quantity, :unit_price, :_destroy ]
    )
  end

  def update_stock!
    @sale.item_sales.each do |item|
      item.product.decrement!(:stock, item.quantity)
    end
  end

  def restore_stock!
    @sale.item_sales.each do |item|
      item.product.increment!(:stock, item.quantity)
    end
  end

  def validate_stock!
    @sale.item_sales.each do |item|
      if item.product.stock < item.quantity
        raise ActiveRecord::Rollback, "Not enough stock for #{item.product.name}"
      end
    end
  end
end
