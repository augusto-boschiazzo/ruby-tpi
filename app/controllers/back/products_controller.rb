class Back::ProductsController < BackController
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    authorize Product

    @products = Product.includes(:product_category, :images_attachments, :audio_attachment).page(params[:page]).per(params[:per_page])
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
        format.html { redirect_to @product, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
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
        format.html { redirect_to @product, notice: "Product was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @product }
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
      format.html { redirect_to products_path, notice: "Product was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params.expect(:id))
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
        images: []
      )
    end
end
