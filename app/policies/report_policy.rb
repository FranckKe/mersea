class ReportPolicy < ApplicationPolicy
  include Recaptcha::Verify

  def create?
    user.present? || verify_recaptcha(model: record)
  end
end
