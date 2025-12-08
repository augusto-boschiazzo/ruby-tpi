class Back::ProductsController < BackController
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    authorize Product

    @query = params[:query].to_s.strip
    @per_page = params[:per_page].presence&.to_i
    @per_page = 15 unless @per_page&.positive?
    @per_page = 100 if @per_page > 100

    scope = Product.order(created_at: :desc)
    if @query.present?
      term = "%#{@query.downcase}%"
      scope = scope.where("LOWER(name) LIKE ?", term)
    end

    @products = scope.page(params[:page]).per(@per_page)
  end

  # GET /products/1 or /products/1.json
  def show
    @product = Product.find(params[:id])

    authorize @product

    respond_to do |format|
      format.html
      format.json { render json: @product.slice(:id, :price) }
    end
  end

  # GET /products/new
  def new
    @product = Product.new

    authorize @product
  end

  # GET /products/1/edit
  def edit
    authorize @product
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    authorize @product

    respond_to do |format|
      if @product.save
  format.html { redirect_to admin_product_path(@product), notice: "Product was successfully created." }
  format.json { render :show, status: :created, location: admin_product_path(@product) }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    authorize @product

    respond_to do |format|
      if @product.update(product_params)
  format.html { redirect_to admin_product_path(@product), notice: "Product was successfully updated.", status: :see_other }
  format.json { render :show, status: :ok, location: admin_product_path(@product) }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    authorize @product

    @product.destroy!

    respond_to do |format|
  format.html { redirect_to admin_products_path, notice: "Product was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(
        :name,
        :description,
        :author,
        :price,
        :stock,
        :product_type,
        :product_category_id,
        :status,
        :audio,
        :remove_audio,
        :cover,
        images: []
      )
    end
end
