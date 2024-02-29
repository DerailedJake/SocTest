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

@pos_post_descriptions = File.readlines("#{Rails.root}/app/assets/text_files/post_descriptions.txt").map! { |l| l.strip }
@neg_post_descriptions = File.readlines("#{Rails.root}/app/assets/text_files/p_desc_neg.txt").map! { |l| l.strip }

def pos_post_descriptions
  @pos_post_descriptions.sample
end

def neg_post_descriptions
  @neg_post_descriptions.sample
end

@pos_post_comments = File.readlines("#{Rails.root}/app/assets/text_files/post_comments.txt").map! { |l| l.strip }
@neg_post_comments = File.readlines("#{Rails.root}/app/assets/text_files/p_com_neg.txt").map! { |l| l.strip }

def pos_post_comment
  @pos_post_comments.sample
end

def neg_post_comment
  @neg_post_comments.sample
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
  max = 15
  rand(min..max).times do
    picture = random_picture
    title = random_picture.original_filename.split('/')[-1].split('_')[0..-3].join(' ')
    user.stories.create!(
      title: title,
      description: pos_post_descriptions
    )
  end
end

def create_posts(user)
  post_count = rand(24..60)
  p "number of posts - #{post_count}"
  post_count.times do
    if rand(1..10) > 3
      p_body = pos_post_descriptions
      is_positive = true
    else
      p_body = neg_post_descriptions
      is_positive = false
    end
    picture = random_picture
    title = random_picture.original_filename.split('/')[-1].split('_')[0..-3].join(' ')
    post = user.posts.create!(
      body: "#{title} #{p_body}",
      picture: picture
    )
    create_comments(post, is_positive)
  end
end

def create_comments(post, is_positive)
  min = 0
  max = 15
  rand(min..max).times do
    c_body = is_positive ? pos_post_comment : neg_post_comment
    post.comments.create!(
      body: c_body,
      user: @all_users.sample
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

def create_users
  rand(50..80).times do
    User.create!(
      email: Faker::Internet.email,
      password: 'qwerqwer',
      password_confirmation: 'qwerqwer',
      avatar: random_avatar,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      description: user_descriptions
    )
  end
end

User.create!(
  email: 'asdf@asdf.asdf',
  password: 'qwerqwer',
  password_confirmation: 'qwerqwer',
  avatar: random_avatar,
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  description: user_descriptions
)

create_users

@all_users = User.all

# comments made during post creation
@all_users.each do |user|
  p "starting - #{user.first_name}"
  create_posts(user)
  create_stories(user)
  randomly_attach(user)
end
