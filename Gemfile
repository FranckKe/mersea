# frozen_string_literal: true

source 'https://rubygems.org'

gem 'active_model_serializers', '0.10'
gem 'coffee-rails', '~> 5.0'
gem 'devise', '>= 4.6.0'
gem 'devise-i18n', '~> 1'
gem 'devise-jwt', '~> 0.8'
gem 'http_accept_language', '~> 2'
gem 'i18n-js', '~> 3'
gem 'pg', '~> 1'
gem 'postmark', '~> 1'
gem 'puma', '~> 5'
gem 'pundit', '~> 1.1'
gem 'rack-cors', '~> 1'
gem 'rails', '~> 6.1'
gem 'rails-i18n', '~> 6'
gem 'active_storage_validations', '~> 0.9'
gem 'image_processing', '~> 1.12'
gem 'rails_admin', '~> 2.1'
gem 'rails_admin-i18n', '~> 1'
gem 'rails_admin_import', '~> 2'
gem 'rails_admin_state', '~> 1'
gem 'rails_admin_slug', '~> 0.1.3'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'state_machines-activerecord', '~> 0.8'
gem 'thread_safe', '~> 0.3'
gem 'wysiwyg-rails', '~> 2'
# https://github.com/sferik/rails_admin/wiki/Froala-WYSIWYG-HTML-Editor
gem 'bugsnag', '~> 6.6'
gem 'nokogiri', '~> 1.13'

# MRI 3.1 with Rails 6 fix
gem "net-imap"
gem "net-pop"
gem "net-smtp"

group :development do
  gem 'annotate'
  # gem 'debbie', git: 'https://github.com/mdouchement/debbie'
  gem 'listen'
  gem 'rb-readline'
  gem 'rubocop'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'seed_dump'
  gem 'dotenv-rails'
  gem 'http', '~> 5.0.0.pre2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :assets, :development, :test, :production do
  gem 'bulma-rails', '~> 0.7.1'
  gem 'leaflet-rails', '~> 1'
  gem 'sass-rails', '~> 5'
  gem 'uglifier', '~> 4'
end

group :test do
  # Rspec
  gem 'rspec-rails', '~> 5'
  gem 'factory_bot_rails', '~> 6'
  gem 'faker', '~> 2'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'pundit-matchers', '~> 1.4'
  gem 'database_cleaner', '~> 1.7'
  gem 'json-schema', '~> 3'
end
