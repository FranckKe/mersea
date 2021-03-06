# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  name                   :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  senior                 :boolean          default(FALSE)
#  language               :string
#
# Indexes
#
#  index_users_on_email  (email)
#

class User < ApplicationRecord
  include Concerns::UserManager
  include Devise::JWT::RevocationStrategies::MerseaWhitelist
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :registerable,
         :timeoutable,
         :recoverable,
         :rememberable,
         :database_authenticatable,
         :jwt_authenticatable,
         :validatable,
         password_length: 6..128,
         jwt_revocation_strategy: self

  has_many :reports

  validates :email, presence: true
  validates :name, presence: true
  validates :language, presence: true
  validates_format_of :email, with: Devise.email_regexp
  validates :password, presence: true, on: :create
end
