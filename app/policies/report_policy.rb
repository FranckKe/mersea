class ReportPolicy < ApplicationPolicy
  include Recaptcha::Verify

  def create?
    user.logged_in? || verify_recaptcha(model: record)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if user.logged_in? && user.same?(id: user.params[:user_id])
        scope
      else
        scope.where(status: 'accepted')
      end
    end
  end
end
