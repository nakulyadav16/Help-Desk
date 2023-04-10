FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    contact { Faker::Number.number(digits: 10) }
    password { "123456" }
    password_confirmation { "123456" }
    confirmed_at { Time.now }
    department
    dob { Date.today - 20.years }
    role { "user" }
  end
end
