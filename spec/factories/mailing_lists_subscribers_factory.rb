# frozen_string_literal: true

FactoryBot.define do
  factory :mailing_lists_subscriber do
    mailing_list
    subscriber
  end
end
