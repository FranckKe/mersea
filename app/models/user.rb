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
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email)
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable,
         :timeoutable,
         # :trackable,
         :recoverable,
         :rememberable,
         :database_authenticatable,
         :validatable,
         password_length: 6..128

  has_many :reports

  validates :email, presence: true
  validates_format_of :email, with: Devise.email_regexp
  validates :password, presence: true, on: :create

  rails_admin do
    list do
      field :name
      field :email
      field :created_at
      field :sign_in_count
      field :last_sign_in_at
      field :updated_at
      field :reset_password_sent_at
    end
  end
end
