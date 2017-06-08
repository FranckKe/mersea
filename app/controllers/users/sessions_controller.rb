class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    resource = User.find_for_database_authentication(email: params[:user][:email])

    if resource&.valid_password?(params[:user][:password])
      sign_in :user, resource
      flash.discard
      render json: { message: I18n.t("devise.failure.#{env['warden'].message}") }, status: :created && return
    end
    invalid_login_attempt
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  def invalid_login_attempt
    error_message = I18n.t("devise.failure.#{env['warden'].message}.not_found_in_database")
    flash[:alert] = error_message
    render json: { message: error_message }, status: :bad_request
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  end
end
