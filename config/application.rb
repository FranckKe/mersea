require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mersea
  class Application < Rails::Application
    # TODO make Flash Message workin for RailsAdmin with the option `config.api_only = true`
    # config.api_only = true
    #
    # # ActiveAdmin compatibility
    # config.middleware.use Rack::MethodOverride
    # config.middleware.use ActionDispatch::Flash
    # config.middleware.use ActionDispatch::Cookies
    # config.middleware.use ActionDispatch::Session::CookieStore

    config.active_storage.service = :local
    config.eager_load_paths << Rails.root.join('lib')
  end
end
