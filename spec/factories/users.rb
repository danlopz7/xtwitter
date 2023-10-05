FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name.downcase }
    lastname { Faker::Name.last_name}
    username { Faker::Internet.username(specifier: "#{name}_#{lastname}", separators: %w(. _ -)) }
    email { Faker::Internet.email(name: "#{name}-#{lastname}", separators: ['-'], domain: 'test')}
    #password { Faker::Internet.password(min_length: 12, max_length: 20, mix_case: true, special_characters: true) }
    password { "TestPassword123!" }
    password_confirmation { "TestPassword123!" }
  end

  trait :registered_user do
    email { Faker::Internet.email }
    password { "TestPassword123!" }
    pasword_confirmation { "TestPassword123!" }
  end
end
