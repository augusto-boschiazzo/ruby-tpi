class SalesController < ApplicationController
  before_action :set_sale, only: %i[ show ]

  def new
    @sale = Sale.new
    @sale.build_client
    @sale.item_sales.build
  end

  def index
    @sales = Sale.includes(:client).order(sold_at: :desc)
  end

  def show
  end

  def create
    client_attrs = sale_params[:client_attributes]
    dni = client_attrs[:dni]

    client = Client.find_by(dni: dni)

    if client
      @sale = Sale.new(sale_params.except(:client_attributes).merge(client: client))
    else
      @sale = Sale.new(sale_params)
    end

    @sale.user = current_user

    respond_to do |format|
      if @sale.save
        format.html { redirect_to @sale, notice: "Venta creada con éxito." }
        format.json { render :show, status: :created, location: @sale }
      else
        @sale.build_client unless @sale.client
        @sale.item_sales.build if @sale.item_sales.empty?
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
      :user_id,
      client_attributes: [ :name, :dni, :email ],
      item_sales_attributes: [ :id, :product_id, :quantity, :unit_price, :_destroy ]
    )
  end
end
