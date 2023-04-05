FactoryBot.define do
  factory :department do
    department_name { Faker::Name.name }
  end
end
