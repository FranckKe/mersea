FactoryBot.define do
  factory :report do
    association :user
    association :tracer

    name { Faker::Name.name }
    quantity { Random.new.rand(42)+1 }
    longitude { Random.new.rand(42) }
    latitude { Random.new.rand(42) }
    description { Faker::Lorem.sentence }
    address { Faker::Lorem.sentence }
    status :accepted
    reported_at { Time.now }

    after(:build) do |instance|
      instance.photo.attach(
        io: File.open("#{Rails.root}/spec/support/fixtures/image.png"),
        filename: 'image.png',
        content_type: 'image/png')
    end
  end
end
