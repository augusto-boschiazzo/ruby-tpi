class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(profile_params)
      redirect_to profile_path, notice: "Perfil actualizado correctamente."
    else
      flash.now[:alert] = "No pudimos actualizar tu perfil. Revisá los errores e intentá nuevamente."
      render :show, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    permitted = [ :name, :last_name, :email ]

    if params[:user].present?
      password = params[:user][:password]
      permitted += [ :password, :password_confirmation ] if password.present?
    end

    params.require(:user).permit(permitted)
  end
end
