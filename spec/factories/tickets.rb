FactoryBot.define do
  factory :ticket do
    subject { 3.times.map { (0...(rand(10))).map { ('a'..'z').to_a[rand(26)] }.join }.join(' ') }
    description { 20.times.map { (0...(rand(10))).map { ('a'..'z').to_a[rand(26)] }.join }.join(' ') }
    due_date { Faker::Date.forward(days: 3) }
    priority { 'High' }
    assigned_to_id { rand(1..10) }
    creator_id { rand(1..10) }
    department_id { rand(1..10) }
    status { 'open' }
  end
end
