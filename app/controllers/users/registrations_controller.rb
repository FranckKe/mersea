class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  prepend_before_action :check_captcha, only: [:create]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    build_resource(sign_up_params)
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
        sign_in(resource)
        respond_to do |format|
          format.html { set_flash_message :notice, :signed_up }
          format.json { render json: { message: find_message(:signed_up, {}) }, status: :created }
        end
      else
        expire_data_after_sign_in!
        respond_to do |format|
          format.html { set_flash_message :alert, :"signed_up_but_#{resource.inactive_message}" }
          format.json { render json: { message: find_message(:"signed_up_but_#{resource.inactive_message}", {}) }, status: :created }
        end
      end
    else
      msg = resource.errors.full_messages.join('<br>').html_safe
      clean_up_passwords resource
      respond_to do |format|
        format.html { set_flash_message :alert, msg }
        format.json { render json: { message: msg }, status: :bad_request }
      end
    end
  end

  private

  def check_captcha
    return if verify_recaptcha
    respond_to do |format|
      format.html { set_flash_message :alert, 'Veuillez confirmer que vous n\'êtes pas un robot' }
      format.json { render json: { message: 'Veuillez confirmer que vous n\'êtes pas un robot' }, status: :bad_request }
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :password, :password_confirmation])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
