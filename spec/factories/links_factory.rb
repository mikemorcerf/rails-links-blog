FactoryBot.define do
  factory :link do
    url { "MyString" }
    icon { "MyString" }
    order { 1 }
    display { false }
    user { nil }
  end
end
