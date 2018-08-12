FactoryBot.define do
  factory :page do
    name { Faker::Name.name }
    content { Faker::Lorem.sentence }
    language 'en'
    slug 'my-page'
  end
end
