# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    title { Faker::Lorem.sentence }
    url { Faker::Internet.url }
    icon { Faker::Lorem.sentence }
    display { true }

    after(:build) do |link|
      link.user = User.first || create(:user)
    end

    trait :invisible do
      display { false }
    end
  end
end
