# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception unless -> { request.format.json? }
  before_action :set_locale
  before_action :fetch_pages

  def status
    render json: {}, status: :ok
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

    preferred_locale = preferred_language_from I18n.available_locales
    I18n.locale = preferred_locale || I18n.default_locale
  end

  def preferred_locale_from_user
    return unless current_user&.language
    user_preferred_languages.unshift(current_user.language)
  end

  def preferred_locale_from_param
    return unless params[:locale]
    user_preferred_languages.unshift(params[:locale])
  end

  def user_preferred_languages
    @user_preferred_languages ||= begin
      request.headers.env['HTTP_ACCEPT_LANGUAGE'].to_s.gsub(/\s+/, '').split(',').map do |language|
        locale, quality = language.split(';q=')
        raise ArgumentError, 'Not correctly formatted' unless locale =~ /^[a-z\-0-9]+|\*$/i

        locale  = locale.downcase.gsub(/-[a-z0-9]+$/i, &:upcase)
        locale  = nil if locale == '*'

        quality = quality ? quality.to_f : 1.0

        [locale, quality]
      end.sort do |(_, left), (_, right)|
        right <=> left
      end.map(&:first).compact
    rescue ArgumentError # Just rescue anything if the browser messed up badly.
      []
    end
  end

  def preferred_language_from(array)
    (user_preferred_languages & array.map(&:to_s)).first
  end
end
