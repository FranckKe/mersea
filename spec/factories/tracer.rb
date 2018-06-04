FactoryBot.define do
  factory :tracer do
    name { Faker::Name.title }
    description { Faker::Lorem.sentence }
    origin { Faker::Lorem.sentence }
    kind { Faker::Lorem.word }
    color { Faker::Color.hex_color }

    after(:build) do |instance|
      instance.photo.attach(
        io: File.open("#{Rails.root}/spec/support/fixtures/image.png"),
        filename: 'image.png',
        content_type: 'image/png')
    end
  end
end
