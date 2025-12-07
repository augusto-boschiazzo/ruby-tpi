class Back::SalesController < BackController
  before_action :set_sale, only: %i[cancel invoice show]

  def new
    @sale = Sale.prepare_new
  end

  def index
    @sales = Sale.includes(:client).order(sold_at: :desc)

    if params[:client_name].present?
      @sales = @sales.joins(:client)
                     .where("LOWER(clients.name) LIKE ?", "%#{params[:client_name].downcase}%")
    end

    if params[:from_date].present?
      @sales = @sales.where("sold_at >= ?", params[:from_date])
    end

    if params[:to_date].present?
      @sales = @sales.where("sold_at <= ?", params[:to_date])
    end

    if params[:status].present?
      case params[:status]
      when "active"
        @sales = @sales.where(cancelled_at: nil)
      when "cancelled"
        @sales = @sales.where.not(cancelled_at: nil)
      end
    end

    @sales = @sales.page(params[:page]).per(10)
  end

  def show; end

  def create
    @sale = Sale.build_with_client(sale_params, current_user)

    respond_to do |format|
      if @sale.save
        format.html { redirect_to admin_sale_path(@sale), notice: "Venta creada con éxito." }
        format.json { render :show, status: :created, location: admin_sale_path(@sale) }
      else
        @sale.prepare_associations
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  def cancel
    @sale.cancel!
    redirect_to admin_sale_path(@sale), notice: "Venta cancelada y stock restaurado."
  end

  def invoice
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "invoice_#{@sale.id}",
               template: "back/sales/invoice",
               layout: "pdf",
               formats: [ :html ],
               encoding: "UTF-8"
      end
    end
  end

  private

  def set_sale
    @sale = Sale.with_details.find(params[:id])
  end

  def sale_params
    params.require(:sale).permit(
      :user_id,
      client_attributes: %i[name dni email],
      item_sales_attributes: %i[id product_id quantity unit_price _destroy]
    )
  end
end
