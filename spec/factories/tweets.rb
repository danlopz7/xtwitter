# FactoryBot.define do
#   factory :tweet do
#     user { nil }
#     content { "MyString" }
#     retweet_id { 1 }
#     quote_id { 1 }
#   end
# end

FactoryBot.define do
  # Factory designed to create normal tweets, retweets and quotes.
  factory :tweet do
    # esta oración suele tener entre 4 a 6 palabras.
    content { Faker::Lorem.sentence }
    # tweet pertenece a un user. Creara automaticamente un user usando la factory
    # user cada vez que creo un tweet.
    user

    # subfabrica para un retweet. Cuando quiera un retweet, factoryBot usara esto
    factory :retweet do
      # asociación con otro tweet(el tweet original)
      #association :original_retweet, factory: :tweet
      original_retweet { create(:tweet) }
    end

    # subfábrica para crear citas de tweets
    factory :quote do
      content { Faker::Lorem.sentence }
      original_quote { create(:tweet) }
      #association :original_quote, factory: :tweet
    end
  end
end
