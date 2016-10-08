source 'https://rubygems.org'
ruby '2.3.1'

gem 'rails', '~> 5.0.0'
gem 'puma', '~> 3.0'
gem 'pg'
gem 'paperclip', '~> 5.0.0'
gem 'devise', '~> 4.2'
gem 'rails_admin', '~> 1.0'
gem 'rails_admin-i18n', '~> 1.10'
gem 'state_machines-activerecord', '~> 0.4.0'
gem 'rails_admin_state', '~> 1.5'

group :development, :test do
  gem 'byebug', platform: :mri
end

group :development do
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'debbie'
  gem 'rubocop', '0.43'
  gem 'annotate'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :assets, :development, :test, :production do
  gem 'jquery-rails', '~> 4.2'
  gem 'foundation-rails', '~> 6.2'
  gem 'foundation-icons-sass-rails', '~> 3.0'
  gem 'devise-foundation-views'
  gem 'sass-rails', '~> 5.0'
  gem 'turbolinks', '~> 5'
  gem 'uglifier', '>= 1.3.0'
  gem 'leaflet-rails', '~> 0.7.7'
  gem 'leaflet-markercluster-rails', '~> 0.7.0'
end
