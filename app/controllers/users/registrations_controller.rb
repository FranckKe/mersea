class Users::RegistrationsController < Devise::RegistrationsController
  include Recaptcha::Adapters::ControllerMethods

  respond_to :json
  before_action :configure_sign_up_params, only: [:create]
  prepend_before_action :check_captcha, only: [:create]

  def create
    build_resource(sign_up_params.merge(language: I18n.locale))
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
        sign_in(resource)
        render json: resource, status: :created
      else
        expire_data_after_sign_in!
        render json: resource, status: :created
      end
    else
      clean_up_passwords(resource)
      @error = Mersea::Errors.format(resource.errors)
      render json: @error, status: @error.status
    end
  end

  private

  def check_captcha
    return if verify_recaptcha
    @error = Mersea::Errors.format(Pundit::NotAuthorizedError.new(record: resource))
    render json: @error, status: @error.status
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation])
  end

  # API mode
  def is_navigational_format?
    false
  end
end
