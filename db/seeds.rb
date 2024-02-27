# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

def random_picture
  Rack::Test::UploadedFile.new("#{Rails.root}/app/assets/images/#{rand(1..8)}.jpeg", 'jpeg')
end
def create_posts(user)
  min = 15
  max = 40
  rand(min..max).times do
    user.posts.create(
      body: Faker::Lorem.sentence(word_count: 10),
      picture: random_picture
    )
  end
end

def create_stories(user)
  min = 3
  max = 7
  rand(min..max).times do
    user.stories.create(
      title: Faker::Lorem.sentence(word_count: 3),
      description: Faker::Lorem.sentence(word_count: 10)
    )
  end
end

def randomly_attach(user)
  posts = user.posts
  stories = user.story_ids
  stories << nil
  posts.each do |post|
    post.update(story_ids: stories.sample)
  end
end

user = User.create(
  email: 'asdf@asdf.asdf',
  password: 'qwerqwer',
  password_confirmation: 'qwerqwer',
  avatar: random_picture
)

create_posts(user)
create_stories(user)
randomly_attach(user)

20.times do
  user = User.create(
    email: Faker::Internet.email,
    password: 'qwerqwer',
    password_confirmation: 'qwerqwer',
    avatar: random_picture
  )
  create_posts(user)
  create_stories(user)
  randomly_attach(user)
end