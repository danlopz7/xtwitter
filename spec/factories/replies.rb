FactoryBot.define do
  factory :reply do
    id { 1 }
    content { "MyString" }
    user_id { 1 }
    tweet_id { 1 }
    reply_id { 1 }
  end
end
