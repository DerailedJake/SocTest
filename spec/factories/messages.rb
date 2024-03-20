FactoryBot.define do
  factory :message do
    content { Faker::Lorem.word }
  end
end
