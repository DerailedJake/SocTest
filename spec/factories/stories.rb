FactoryBot.define do
  factory :story do
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.sentence(word_count: 10) }
    user
  end
end
