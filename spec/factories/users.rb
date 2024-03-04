FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    description { Faker::Lorem.sentence(word_count: 12) }
    email { Faker::Internet.email }
    avatar { Rack::Test::UploadedFile.new("#{Rails.root}/app/assets/images/user_avatars/1.jpeg", 'jpeg') }
    password { Faker::Internet.password }
  end
end


def user_with_posts_and_stories(object_count: 7)
  FactoryBot.create(:user) do |user|
    FactoryBot.create_list(:post, object_count, user: user)
    FactoryBot.create_list(:story, object_count, user: user)
  end
end
