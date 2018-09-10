# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
# Production namespace like `https://my_url/mersea/admin`
map ENV['MERSEA_NAMESPACE'] if ENV['MERSEA_NAMESPACE']

run Rails.application

require 'rack/cors'
use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: %i(get post put patch delete options),
                  expose: ['Authorization']
  end
end
