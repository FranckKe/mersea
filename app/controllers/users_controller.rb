class UsersController < ApiController
  before_action :authenticate_user!
  before_action :authorize_user!, only: %i(me update update_password)

  def me
    render json: current_user, status: :ok
  end

  def update
    if current_user.update_with_password(update_params)
      render json: current_user, status: :ok
    else
      @error = Mersea::Errors.format(current_user.errors)
      render json: @error, status: @error.status
    end
  end

  def update_password
    if current_user.update_with_password(update_password_params)
      render json: current_user, status: :ok
    else
      @error = Mersea::Errors.format(current_user.errors)
      render json: @error, status: @error.status
    end
  end

  def destroy
    if current_user.reports.update_all(name: '∅')
      current_user.destroy
      render nothing: true, status: :no_content
    else
      @error = Mersea::Errors.format(current_user.errors)
      render json: @error, status: @error.status
    end
  end

  protected

  private

  def authorize_user!
    authorize current_user
  end

  def update_params
    params.permit(:name, :email, :language, :current_password)
  end

  def update_password_params
    params.permit(:password, :password_confirmation, :current_password)
  end
end
