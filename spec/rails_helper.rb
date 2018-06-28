ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'faker'
require 'pundit/matchers'
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each do |f|
  require f
end

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include RequestsHelper, type: :request
  config.include Rails.application.routes.url_helpers

  config.before do
    DatabaseCleaner.strategy = :deletion, { except: %w(neighborhoods) }
    DatabaseCleaner.clean
  end

  config.after(:all) do
    FileUtils.rm_rf(Rails.root.join("tmp/storage")) # Update config/storage.yml if you change this
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    with.library :rails
  end
end
