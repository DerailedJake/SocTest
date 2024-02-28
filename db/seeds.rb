# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


@all_user_descriptions = File.readlines("#{Rails.root}/app/assets/text_files/user_descriptions.txt").map! { |l| l.strip }

def user_descriptions
  @all_user_descriptions.sample
end

@all_post_descriptions = File.readlines("#{Rails.root}/app/assets/text_files/post_descriptions.txt").map! { |l| l.strip }

def post_descriptions
  @all_post_descriptions.sample
end

def random_avatar
  Rack::Test::UploadedFile.new(
    Dir.glob("#{Rails.root}/app/assets/images/user_avatars/*.jpeg").sample,
    'jpeg')
end

def random_picture
  Rack::Test::UploadedFile.new(
    Dir.glob("#{Rails.root}/app/assets/images/post_pictures/*.jpeg").sample,
    'jpeg')
end

def create_stories(user)
  min = 3
  max = 7
  rand(min..max).times do
    picture = random_picture
    title = random_picture.original_filename.split('/')[-1].split('_')[0..-3].join(' ')
    user.stories.create(
      title: title,
      description: post_descriptions
    )
  end
end

def create_posts(user)
  min = 15
  max = 40
  rand(min..max).times do
    picture = random_picture
    title = random_picture.original_filename.split('/')[-1].split('_')[0..-3].join(' ')
    user.posts.create(
      body: "#{title} #{post_descriptions}",
      picture: picture
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
  avatar: random_avatar,
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  description: user_descriptions
)

create_posts(user)
create_stories(user)
randomly_attach(user)

20.times do
  user = User.create(
    email: Faker::Internet.email,
    password: 'qwerqwer',
    password_confirmation: 'qwerqwer',
    avatar: random_avatar,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    description: user_descriptions
  )
  create_posts(user)
  create_stories(user)
  randomly_attach(user)
end
