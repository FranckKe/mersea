class UsersController < ApplicationController
  before_action :authenticate_user!

  def me
    return unless request.method_symbol == :post
    if current_user.update_attributes(update_params)
      render json: { message: I18n.t('devise.registrations.updated') }, status: 200
    else
      render json: { message: current_user.errors.full_messages }, status: 200
    end
  end

  def after_sign_in_path_for
    URI.parse(request.referer).path if request.referer
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update_with_password(update_password_params)
      bypass_sign_in(@user)
      render json: { message: I18n.t('devise.passwords.updated_not_active') }, status: 200
    else
      render json: { message: 'Mot de passe actuel incorrect' }, status: 401
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
