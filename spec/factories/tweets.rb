FactoryBot.define do
  factory :tweet do
    user { nil }
    content { "MyString" }
    retweet_id { 1 }
    quote_id { 1 }
  end
end
