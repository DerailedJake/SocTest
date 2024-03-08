FactoryBot.define do
  factory :post do
    body { Faker::Lorem.sentence(word_count: 10) }
    picture { Rack::Test::UploadedFile.new("#{Rails.root}/app/assets/images/test_pic.jpeg", 'jpeg') }
    user
  end
end
