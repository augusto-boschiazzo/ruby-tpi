class Back::UsersController < BackController
    before_action :set_user, only: %i[ show edit update destroy ]
    
    # GET /users or /users.json
    def index
        authorize User

        @query = params[:query].to_s.strip
        @per_page = params[:per_page].presence&.to_i
        @per_page = 15 unless @per_page&.positive?
        @per_page = 100 if @per_page > 100

        scope = User.order(created_at: :desc)
        if @query.present?
            term = "%#{@query.downcase}%"
            scope = scope.where("LOWER(email) LIKE ?", term)
        end

        @users = scope.page(params[:page]).per(@per_page)
    end
    
    # GET /users/1 or /users/1.json
    def show
        authorize @user

        respond_to do |format|
        format.html
        format.json { render json: @user.slice(:id, :email) }
        end
    end
    
    # GET /users/new
    def new
        @user = User.new
    
        authorize @user
    end
    
    # GET /users/1/edit
    def edit
        authorize @user
    end

    # POST /users or /users.json
    def create
        @user = User.new(user_params)
    
        authorize @user
    
        respond_to do |format|
        if @user.save
            format.html { redirect_to admin_user_path(@user), notice: "User was successfully created." }
            format.json { render :show, status: :created, location: admin_user_path(@user) }
        else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @user.errors, status: :unprocessable_entity }
        end
        end
    end

    # PATCH/PUT /users/1 or /users/1.json
    def update
        authorize @user

        respond_to do |format|
        if @user.update(user_params)
            format.html { redirect_to admin_user_path(@user), notice: "User was successfully updated." }
            format.json { render :show, status: :ok, location: admin_user_path(@user) }
        else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @user.errors, status: :unprocessable_entity }
        end
        end
    end

    # DELETE /users/1 or /users/1.json
    def destroy
        authorize @user

        respond_to do |format|
        if @user.destroy
            format.html { redirect_to admin_users_url, notice: "User was successfully destroyed." }
            format.json { head :no_content }
        else
            format.html { redirect_to admin_users_url, alert: "User could not be destroyed." }
            format.json { render json: @user.errors, status: :unprocessable_entity }
        end
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
        @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
    permitted = [:name, :last_name, :email]
        permitted << :role if current_user&.admin?

        include_passwords = action_name == "create" || current_user == @user
        permitted += [:password, :password_confirmation] if include_passwords

        attrs = params.require(:user).permit(permitted)

        if include_passwords && action_name != "create" && attrs[:password].blank?
            attrs.delete(:password)
            attrs.delete(:password_confirmation)
        end

        if current_user&.admin?
            if action_name == "create"
                attrs[:role] = attrs[:role].presence || "employee"
            elsif @user&.persisted?
                attrs[:role] = attrs[:role].presence || @user.role
            end
        else
            attrs.delete(:role)
            attrs[:role] = "employee" if action_name == "create"
        end

        attrs
    end
end