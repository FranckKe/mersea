class UsersController < ApplicationController
  before_action :authenticate_user!

  def me
    return unless request.method_symbol == :post
    if current_user.update_attributes(update_params)
      set_flash_message :notice, I18n.t('devise.registrations.updated') if is_flashing_format?
      render json: { message: I18n.t('devise.registrations.updated') }, status: :ok
    else
      set_flash_message :notice, current_user.errors.full_messages if is_flashing_format?
      render json: { message: current_user.errors.full_messages }, status: :bad_request
    end
  end

  def after_sign_in_path_for
    URI.parse(request.referer).path if request.referer
  end

  def reports
    @user = User.find(params[:id])
    @reports = @user.reports

    respond_to do |format|
      format.html
      format.json do
        render json: { data: @reports },
               include: { tracer: { only: :name } },
               except: [:email, :photo_content_type, :photo_file_name, :photo_file_size, :photo_updated_at, :created_at, :updated_at ]
      end
    end
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update_with_password(update_password_params)
      bypass_sign_in(@user)
      set_flash_message :notice, I18n.t('devise.passwords.updated_not_active') if is_flashing_format?
      render json: { message: I18n.t('devise.passwords.updated_not_active') }, status: :created
    else
      set_flash_message :notice, 'Mot de passe actuel incorrect' if is_flashing_format?
      render json: { message: 'Mot de passe actuel incorrect' }, status: :bad_request
    end
  end

  private

  def update_params
    params.require(:user).permit(:name, :email)
  end

  def update_password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
end