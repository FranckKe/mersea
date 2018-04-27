# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception unless -> { request.format.json? }
  before_action :set_locale

  protected

  # Compatible redirection with Rails API
  def after_sign_in_path_for(resource)
    if resource.is_a?(Admin)
      rails_admin_path
    else
      super
    end
  end

  # Compatible redirection with Rails API
  def after_sign_out_path_for(resource)
    if resource == :admin || resource.is_a?(Admin)
      new_admin_session_path
    else
      super
    end
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
