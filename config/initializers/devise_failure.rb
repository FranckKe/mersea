class CustomFailure < Devise::FailureApp
  def redirect_url
    new_admin_session_url if admin?
  end

  def respond
    unless admin? # API Users
      self.status = :unauthorized
      self.response_body = { errors: i18n_message }.to_json
      self.content_type = 'application/json; charset=utf-8'
      return
    end

    if http_auth?
      http_auth
    else
      redirect
    end
  end

  private

  def admin?
    warden_options[:scope] == :admin
  end
end
