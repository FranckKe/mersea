class UserPolicy < ApplicationPolicy
  include Recaptcha::Verify

  def me?
    owner?
  end

  def update?
    owner?
  end

  def update_password?
    owner?
  end

  private

  def owner?
    record.id == user.id
  end
end
