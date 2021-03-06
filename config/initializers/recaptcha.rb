Recaptcha.configure do |config|
  config.site_key = Rails.application.secrets.recaptcha[:site_key]
  config.secret_key = Rails.application.secrets.recaptcha[:secret_key]
  config.skip_verify_env << 'development'
  config.skip_verify_env << 'production'
end
