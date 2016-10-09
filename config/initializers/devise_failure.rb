class CustomFailure < Devise::FailureApp
  def redirect_url
    if (port = ENV['DEVISE_FORCE_PORT'])
      # Overrides default ports when the server is behind several proxies
      url = URI.parse(new_admin_session_url)
      url.port = port
      url.to_s
    else
      new_admin_session_url
    end
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
