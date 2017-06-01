class UsersController < ApplicationController
  before_action :authenticate_user!

  def me
    if request.method_symbol == :post
      if current_user.update_attributes(update_params)
        flash[:success] = 'Profil mis à jour'
      else
        flash[:alert] = current_user.errors.full_messages
      end
    end
  end

  def after_sign_in_path_for
    URI.parse(request.referer).path if request.referer
  end

  def update_params
    params.require(:user).permit(:name, :email)
  end
end
