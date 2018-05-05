# == Schema Information
#
# Table name: access_tokens
#
#  id         :uuid             not null, primary key
#  user_id    :uuid             not null
#  jti        :string           not null
#  aud        :string
#  exp        :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_access_tokens_on_jti      (jti)
#  index_access_tokens_on_user_id  (user_id)
#

class AccessToken < ApplicationRecord
  belongs_to :user
end
