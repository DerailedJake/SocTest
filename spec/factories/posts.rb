FactoryBot.define do
  factory :post do
    body { Faker::Lorem.sentence(word_count: 10) }
    picture { Rack::Test::UploadedFile.new("#{Rails.root}/app/assets/images/post_pictures/25_Pavilion_92_pic.jpeg", 'jpeg') }
  end
end
