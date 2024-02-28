FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.sentence(word_count: 10) }
    post
    user
  end
end
