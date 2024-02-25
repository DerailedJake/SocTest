FactoryBot.define do
  factory :user do
    #first_name { Faker::Name.first_name }
    #last_name  { Faker::Name.last_name }
    email { Faker::Internet.email }
    avatar { Rack::Test::UploadedFile.new("#{Rails.root}/spec/factories/files/test_pic.jpeg", 'jpeg') }
    password { Faker::Internet.password }
  end
end
