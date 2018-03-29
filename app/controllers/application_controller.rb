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

  def set_locale
    I18n.locale = I18n.available_locales.include?(params[:locale]&.to_sym) ? params[:locale] : I18n.default_locale
    @locale = languages[I18n.locale]
    @available_locales = other_available_locales
  end

  def default_url_options(options = {})
    options.merge(locale: I18n.locale)
  end

  def languages
    @languages ||= ActiveSupport::HashWithIndifferentAccess.new.tap do |langs|
      I18n.backend.available_locales # Load translations
      I18n.backend.send(:translations).each do |lang, hsh|
        langs[lang] = hsh[:name]
      end
    end
  end

  def available_locales
    I18n.available_locales.map do |lang|
      {
        language: lang,
        translation: languages[lang]
      }
    end
  end

  def other_available_locales
    available_locales.map do |lang|
      lang if lang[:language] != I18n.locale
    end.compact
  end
end
