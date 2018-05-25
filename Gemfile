# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.5.1'

gem 'active_model_serializers', '0.10'
gem 'devise', '~> 4'
gem 'devise-i18n', '~> 1'
gem 'devise-jwt', '~> 0.5.6'
gem 'http_accept_language', '~> 2'
gem 'i18n-js', '~> 3'
gem 'pg', '~> 1'
gem 'postmark', '~> 1'
gem 'puma', '~> 3'
gem 'pundit', '~> 1.1'
gem 'rack-cors', '~> 1'
gem 'rails', '~> 5.2'
gem 'rails-i18n', '~> 5'
gem 'image_processing', '~> 1.2'
gem 'rails_admin', git: 'https://github.com/dtcristo/rails_admin.git', branch: 'active_storage'
gem 'rails_admin-i18n', '~> 1'
gem 'rails_admin_import', '~> 2'
gem 'rails_admin_state', '~> 1'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'state_machines-activerecord', '~> 0.5'
gem 'wysiwyg-rails', '~> 2'
# https://github.com/sferik/rails_admin/wiki/Froala-WYSIWYG-HTML-Editor
gem 'bugsnag', '~> 6.6'

group :development do
  gem 'annotate'
  gem 'debbie'
  gem 'listen'
  gem 'rb-readline'
  gem 'rubocop'
  gem 'spring'
  gem 'spring-watcher-listen'
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
  gem 'rspec-rails', '~> 3.7'
  gem 'factory_bot_rails', '~> 4.8'
  gem 'faker', '~> 1.8'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'pundit-matchers', '~> 1.4'
  gem 'database_cleaner', '~> 1.7'
  gem 'json-schema', '~> 2.8'
end
