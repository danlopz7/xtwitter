FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name.downcase }
    lastname { Faker::Name.last_name}
    username { Faker::Internet.username(specifier: "#{name}_#{lastname}", separators: %w(. _ -)) }
    email { Faker::Internet.email(name: "#{name}-#{lastname}", separators: ['-'], domain: 'test')}
    password { Faker::Internet.password(min_length: 12, max_length: 20, mix_case: true, special_characters: true) }
    #pasword { "Password123!" }
  end
end
