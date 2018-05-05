class Users::PasswordsController < Devise::PasswordsController
  append_before_action :assert_reset_token_passed, only: :edit
  respond_to :json

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      render json: resource, status: :created
    else
      @error = Mersea::Errors.format(resource.errors)
      render json: @error, status: @error.status
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      if Devise.sign_in_after_reset_password
        sign_in(resource_name, resource)
        render json: resource, status: :ok
      else
        render json: resource, status: :ok
      end
    else
      set_minimum_password_length
      @error = Mersea::Errors.format(resource.errors)
      render json: @error, status: @error.status
    end
  end

  protected

  # API mode
  def is_navigational_format?
    false
  end
end
