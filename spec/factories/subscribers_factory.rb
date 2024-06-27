# frozen_string_literal: true

FactoryBot.define do
  factory :subscriber do
    email { Faker::Internet.email }
    mailing_lists { [] }

    trait :post_newsletter_subscriber do
      mailing_lists { [MailingList.find_or_create_by(name: 'post_newsletter')] }
    end
  end
end
