# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(scope: :user)
    sign_in(resource_name, resource)
    yield resource if block_given?

    render json: resource
  end

  protected

  # Devise hack for JWT support
  def all_signed_out?
    users = Devise.mappings.keys.map do |s|
      warden.user(scope: s, run_callbacks: false) || jwt_user(s)
    end

    users.all?(&:blank?)
  end

  def jwt_user(scope)
    return nil if bearer.blank?
    Warden::JWTAuth::UserDecoder.new.call(bearer, scope, nil)
  rescue Warden::JWTAuth::Errors::RevokedToken
    return nil
  end

  def bearer
    request.headers['Authorization']&.gsub('Bearer ', '')
  end

  # Hack Devise for Rails 5 API for `DELETE /resource/sign_out`.
  def respond_to_on_destroy
    render nothing: true, status: :no_content
  end
end
