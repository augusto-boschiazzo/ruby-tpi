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
    @sale = Sale.create_with_stock!(sale_params, current_user)
    redirect_to @sale, notice: "Venta creada con éxito."
  rescue ActiveRecord::Rollback => e
    flash.now[:alert] = e.message
    @sale ||= Sale.new(sale_params)
    render :new, status: :unprocessable_entity
  end

  def show
    # Lo dejo vacio por el before_action
  end

  def cancel
    if @sale.cancelled_at.nil?
      @sale.update(cancelled_at: Time.current)
      flash[:notice] = "Venta cancelada y stock restaurado."
    else
      flash[:alert] = "La venta ya estaba cancelada."
    end

    redirect_to sale_path(@sale)
  end

  private

  def set_sale
    @sale = Sale.find(params[:id])
  end

  def sale_params
  params.require(:sale).permit(
    :sold_at, :client_dni, :client_name,
    item_sales_attributes: [ :product_id, :quantity, :unit_price, :_destroy ]
  )
  end
end
