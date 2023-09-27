FactoryBot.define do
  factory :bookmark do
    user { association :user }
    tweet { association :tweet }
  end
end
