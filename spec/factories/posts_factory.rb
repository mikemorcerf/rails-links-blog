FactoryBot.define do
  factory :post do
    title { "MyString" }
    video_url { "MyString" }

    association :user
  end
end
