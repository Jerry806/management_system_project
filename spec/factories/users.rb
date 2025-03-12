FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password123" }
    authentication_token { SecureRandom.hex(10) }
  end
end
