FactoryBot.define do
  factory :department do
    department_name { Faker::Company.name }
  end
end
