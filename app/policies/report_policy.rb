class ReportPolicy < ApplicationPolicy
  include Recaptcha::Verify

  def create?
    user.logged_in? || verify_recaptcha(model: record)
  end
end
