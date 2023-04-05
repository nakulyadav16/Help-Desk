FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    contact {  10.times.map { rand(0..9) }.join }
    # sequence(:department_id) {|n| "#{n}"  }
    password { rand(6..10).times.map { ('a'..'z').to_a[rand(26)] }.join }
    dob { Faker::Date.birthday(min_age: 18, max_age: 65) }
    department_id { FactoryBot.create(:department).id }
  end
end
