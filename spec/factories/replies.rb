FactoryBot.define do
  factory :reply do
    content { "MyString" }
    user { nil }
    tweet { nil }
  end
end
