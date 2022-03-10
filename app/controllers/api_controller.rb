# frozen_string_literal: true

class ApiController < ActionController::API
  include ActionController::MimeResponds
  include Pundit
  before_action :set_default_format

  def status
    render json: {}, status: :ok
  rescue ActionDispatch::Http::MimeNegotiation::InvalidType
    # FIXME: find a better way to handle this case.
    # `set_default_format' should avoid this case.
    render json: {}, status: :ok
  end

  rescue_from StandardError do |e|
    @error = Mersea::Errors.format(e)
    render json: @error, status: @error.status
  end

  private

  # Customize pundit's user
  # https://github.com/varvet/pundit#additional-context
  def pundit_user
    UserContext.new(current_user, params)
  end

  def set_default_format
    request.format = :json if request.headers['ACCEPT'].blank?
  end
end
