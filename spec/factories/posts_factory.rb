FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    video_url { Faker::Internet.url }
    body { "<p>#{SecureRandom.alphanumeric(8)}</p>" }
    deliver_newsletter { false }

    after(:build) do |post|
      post.user = User.first || create(:user)
    end
  end
end
