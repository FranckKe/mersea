class CustomFailure < Devise::FailureApp
  def respond
    self.status = :unauthorized
    self.response_body = { errors: i18n_message }.to_json
    self.content_type = 'application/json; charset=utf-8'
  end
end
