class UserContext
  attr_reader :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end

  def logged_in?
    user.present?
  end

  def same?(hsh)
    return false if user.blank?
    hsh.all? do |k, v|
      if k == :password
        user.valid_password?(v)
      else
        user.send(k) == v
      end
    end
  end
end
