FactoryBot.define do
  factory :reply do
    content { Faker::Lorem.sentence(word_count: 5) }
    user
    tweet
  end
end
