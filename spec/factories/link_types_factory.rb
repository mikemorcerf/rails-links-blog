FactoryBot.define do
  factory :link_type do
    name { Faker::Loren.word }

    association :link
  end
end
