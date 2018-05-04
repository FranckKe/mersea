FactoryBot.define do
  factory :access_token do
    association :user

    jti { SecureRandom.uuid }
    exp { Time.now+1.week }
  end
end
