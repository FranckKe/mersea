# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception unless -> { request.format.json? }
  before_action :set_locale
  before_action :fetch_pages

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

  def fetch_pages
    # List pages for side menu
    @pages = Page.where(language: I18n.locale)
    @pages = Page.where(language: I18n.default_locale) if @pages.length.zero?
  end

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
