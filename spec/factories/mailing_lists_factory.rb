FactoryBot.define do
  factory :mailing_list do
    name { Faker::Lorem.sentence.parameterize }

    trait :post_newsletter do
      name { 'post_newsletter' }
    end
  end
end
