# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception unless -> { request.format.json? }

  protected

  # Compatible redirection with Rails API
  def after_sign_in_path_for(resource)
    if resource.is_a?(Admin)
      rails_admin_path
    else
      super
    end
  end

  # Compatible redirection with Rails API
  def after_sign_out_path_for(resource)
    if resource == :admin || resource.is_a?(Admin)
      new_admin_session_path
    else
      super
    end
  end
end
