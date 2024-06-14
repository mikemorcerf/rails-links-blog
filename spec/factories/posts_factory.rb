FactoryBot.define do
  factory :post do
    title { "MyString" }
    video_url { "MyString" }

    after(:build) do |post|
      post.user = User.first || create(:user)
    end
  end
end
