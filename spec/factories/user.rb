FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password Faker::Crypto.md5
    language 'en'
  end
end
