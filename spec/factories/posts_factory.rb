FactoryBot.define do
  factory :post do
    title { Faker::Book.title }
    video_url { Faker::Internet.url }
    body { "<p>#{Faker::Lorem.word}</p>" }

    after(:build) do |post|
      post.user = User.first || create(:user)
    end
  end
end
