# frozen_string_literal: true

FactoryBot.define do
  factory :link_type do
    name { Faker::Loren.word }

    link
  end
end
