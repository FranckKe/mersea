# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Pundit
  before_action :set_locale

  def status
    render json: {}, status: :ok
  end

  def index
    render nothing: true
  end

  rescue_from StandardError do |e|
    @error = Mersea::Errors.format(e)
    render json: @error, status: @error.status
  end

  private

  def default_url_options(options = {})
    return options if current_user
    # Add locale to url/path builder ()
    options.merge(locale: I18n.locale)
  end

  def set_locale
    preferred_locale_from_user
    preferred_locale_from_param

    preferred_locale = http_accept_language.preferred_language_from I18n.available_locales
    I18n.locale = preferred_locale || I18n.default_locale
  end

  def preferred_locale_from_user
    return unless current_user&.language
    http_accept_language.user_preferred_languages.unshift(current_user.language)
  end

  def preferred_locale_from_param
    return unless params[:locale]
    http_accept_language.user_preferred_languages.unshift(params[:locale])
  end
end
