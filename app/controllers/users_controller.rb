class UsersController < ApplicationController
  before_action :authenticate_user!

  def me
    return unless request.method_symbol == :post
    if current_user.valid_password?(update_params[:password])
      if current_user.update_attributes(update_params.except(:password))
        respond_to do |format|
          format.html { set_flash_message :notice, I18n.t('devise.registrations.updated') }
          format.json { render json: { message: I18n.t('devise.registrations.updated') }, status: :ok }
        end
      else
        respond_to do |format|
          format.html { set_flash_message :alert, current_user.errors.full_messages }
          format.json { render json: { message: current_user.errors.full_messages.join(', ') }, status: :bad_request }
        end
      end
    else
      respond_to do |format|
        format.html { set_flash_message :alert, I18n.t('devise.failure.invalid') }
        format.json { render json: { message:  I18n.t('devise.failure.invalid') }, status: :unauthorized }
      end
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
    if @user.valid_password?(update_password_params[:current_password])
      if update_password_params[:password] == update_password_params[:password_confirmation]
        if @user.update_attributes(update_password_params.slice(:password))
          bypass_sign_in(@user)
          respond_to do |format|
            format.html { set_flash_message :notice, I18n.t('devise.passwords.updated_not_active') }
            format.json { render json: { message: I18n.t('devise.passwords.updated_not_active') }, status: :created }
          end
        else
          default_message = 'Votre mot de passe doit être compris entre 6 et 128 charactères'
          respond_to do |format|
            format.html { set_flash_message :alert, default_message }
            format.json { render json: { message: default_message }, status: :bad_request }
          end
        end
      else
        respond_to do |format|
          format.html { set_flash_message :alert, 'Les nouveaux mot de passes ne correspondent pas' }
          format.json { render json: { message: 'Les nouveaux mot de passes ne correspondent pas' }, status: :bad_request }
        end
      end
    else
      respond_to do |format|
        format.html { seset_flash_message :alert, I18n.t('devise.failure.invalid') }
        format.json { render json: { message: I18n.t('devise.failure.invalid') }, status: :unauthorized }
      end
    end
  end

  protected

  def set_flash_message(key, kind, options = {})
    if is_flashing_format?
      set_flash_message(key, kind, options)
    end
  end

  private

  def update_params
    params.require(:user).permit(:name, :email, :password)
  end

  def update_password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
end
