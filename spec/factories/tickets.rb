FactoryBot.define do
  factory :ticket do
    subject { Faker::Lorem.sentence(word_count: 5) }
    description { Faker::Lorem.sentence(word_count: 15) }
    due_date { Faker::Date.forward(days: 3) }
    priority { 'High' }
    assigned_to { create(:user) }
    creator { create(:user) }
    department { create(:department) }
    status { 'open' }
  end
end
