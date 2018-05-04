FactoryBot.define do
  factory :tracer do
    name { Faker::Name.name }
    description { Faker::Lorem.sentence }
    origin { Faker::Lorem.sentence }
    kind { Faker::Lorem.word }
    color { Faker::Color.hex_color }
    photo { File.new("#{Rails.root}/spec/support/fixtures/image.png") }
  end
end
