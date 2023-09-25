FactoryBot.define do
  factory :follow do
    follower { 1 }
    followee { 1 }
  end
end
