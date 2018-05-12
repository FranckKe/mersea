module RequestsHelper
  def headers
    {
      'HTTP_ACCEPT' => 'application/json',
      'CONTENT_TYPE' => 'application/json'
    }
  end

  def geojson_headers
    {
      'HTTP_ACCEPT' => 'application/geo+json',
      'CONTENT_TYPE' => 'application/geo+json'
    }
  end

  def headers_with_auth
    headers.merge('HTTP_AUTHORIZATION' => "Bearer #{token}")
  end

  def token
    tk = user.access_tokens.first
    Warden::JWTAuth::TokenEncoder.new.call(
      'sub' => tk.user_id,
      'scp' => 'user',
      'iat' => tk.created_at.to_i,
      'exp' => tk.exp.to_i,
      'jti' => tk.jti
    )
  end

  def user
    find_user.tap do |u|
      if u.access_tokens.blank?
        u.access_tokens << FactoryBot.create(:access_token, user: u)
        u.save!
      end
    end
  end

  def find_user
    return subject if subject.is_a?(User)
    return subject.user if subject.respond_to?(:user)
    FactoryBot.create(:user)
  end
end
