FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    description { Faker::Lorem.sentence(word_count: 12) }
    email { Faker::Internet.email }
    avatar { Rack::Test::UploadedFile.new("#{Rails.root}/app/assets/images/test_avt.jpeg", 'jpeg') }
    password { Faker::Internet.password }
  end
end


def user_with_posts_and_stories(object_count: 7)
  FactoryBot.create(:user) do |user|
    FactoryBot.create_list(:post, object_count, user: user)
    FactoryBot.create_list(:story, object_count, user: user)
  end
end

def user_with_commented_posts_and_story(object_count: 4)
  FactoryBot.create_list(:user, 3)
  FactoryBot.create(:user) do |user|
    FactoryBot.create_list(:story, 1, user: user) do |story|
      FactoryBot.create_list(:post, 1, story_ids: [story.id], user: user) do |post|
        FactoryBot.create_list(:comment, object_count, post: post) do |comment|
          comment.user = User.all.sample
        end
      end
    end
  end
end
