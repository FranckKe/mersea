# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception unless -> { request.format.json? }
  before_action :fetch_pages
  before_action :set_locale

  def status
    render json: {}, status: :ok
  end

  private

  @languages = ActiveSupport::HashWithIndifferentAccess.new(
    en: 'English',
    es: 'Español',
    fr: 'Français'
  )

  def fetch_pages
    @pages = Page.all # For side menu
  end

  def set_locale
    languages = ActiveSupport::HashWithIndifferentAccess.new(
      en: 'English',
      es: 'Español',
      fr: 'Français'
    )
    parsed_locale = I18n.available_locales.map(&:to_s).include?(params[:locale]) ? params[:locale] : I18n.default_locale

    I18n.locale = parsed_locale
    @locale = languages[I18n.locale]
    @available_locales = []
    I18n.available_locales.map do |lang|
      next if lang == I18n.locale
      @available_locales << {
        language: lang,
        translation: languages[lang]
      }
    end
  end

  def default_url_options(options = {})
    options.merge(locale: I18n.locale)
  end

end
