class Users::PasswordsController < Devise::PasswordsController
  append_before_action :assert_reset_token_passed, only: :edit

  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    super
  end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      if Devise.sign_in_after_reset_password
        message = resource.active_for_authentication? ? I18n.t('devise.passwords.updated') : I18n.t('devise.passwords.updated_not_active')
        set_flash_message :notice, message if is_flashing_format?
        sign_in(resource_name, resource)
        render json: { message: message }
      else
        set_flash_message :notice, I18n.t('devise.passwords.updated_not_active') if is_flashing_format?
        render json: { message: I18n.t('devise.passwords.updated_not_active') }
      end
    else
      set_minimum_password_length
      msg = resource.errors.full_messages.join('<br>').html_safe
      render json: { message: msg }, status: :bad_request
    end
  end

  protected

  def after_resetting_password_path_for(resource)
    Devise.sign_in_after_reset_password ? after_sign_in_path_for(resource) : new_session_path(resource_name)
  end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    new_session_path(resource_name) if is_navigational_format?
  end

  # Check if a reset_password_token is provided in the request
  def assert_reset_token_passed
    if params[:reset_password_token].blank?
      set_flash_message :alert, :no_token if is_flashing_format?
      render json: { message: I18n.t('devise.passwords.no_token') }, status: :bad_request
    end
  end
end
