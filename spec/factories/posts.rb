FactoryBot.define do
  factory :post do
    body { Faker::Lorem.sentence(word_count: 10) }
  end
end
