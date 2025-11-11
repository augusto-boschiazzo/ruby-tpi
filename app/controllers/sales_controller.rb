class SalesController < ApplicationController
  before_action :set_sale, only: %i[ show ]

  def new
    @sale = Sale.new
    @sale.item_sales.build
  end

  def index
    @sales = Sale.includes(:client).order(sold_at: :desc)
  end

  def show
  end

  def create
    @sale = Sale.new(sale_params)

    respond_to do |format|
      if @sale.save
        format.html { redirect_to @sale, notice: "Venta creada con éxito." }
        format.json { render :show, status: :created, location: @sale }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  def cancel
    @sale = Sale.find(params[:id])
    @sale.cancel!
    redirect_to @sale, notice: "Venta cancelada y stock restaurado."
  end

  private

  def set_sale
    @sale = Sale.find(params[:id])
  end

  def sale_params
    params.require(:sale).permit(
      :client_id, :user_id,
      item_sales_attributes: [ :id, :product_id, :quantity, :unit_price, :_destroy ]
    )
  end
end
