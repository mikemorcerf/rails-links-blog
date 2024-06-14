FactoryBot.define do
  factory :link do
    title { Faker::Lorem.sentence }
    url { Faker::Internet.url }
    icon { Faker::Lorem.word }
    display { true }
    sequence(:order) { |n| n }

    association :user

    trait :invisible do
      display { false }
    end
  end
end
