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

# Posts
# arch
@pos_post_descriptions = File.readlines("#{Rails.root}/app/assets/text_files/post_descriptions.txt").map! { |l| l.strip }
@neg_post_descriptions = File.readlines("#{Rails.root}/app/assets/text_files/p_desc_neg.txt").map! { |l| l.strip }
# food
@p_desc_pos_food = File.readlines("#{Rails.root}/app/assets/text_files/p_desc_pos_food.txt").map! { |l| l.strip }
@p_desc_neg_food = File.readlines("#{Rails.root}/app/assets/text_files/p_desc_neg_food.txt").map! { |l| l.strip }

def get_post_body(is_positive, type)
  if is_positive
    if type == 'arch'
      @pos_post_descriptions.sample
    else
      @p_desc_pos_food.sample
    end
  else
    if type == 'arch'
      @neg_post_descriptions.sample
    else
      @p_desc_neg_food.sample
    end
  end
end

# Comments
# arch
@pos_post_comments = File.readlines("#{Rails.root}/app/assets/text_files/post_comments.txt").map! { |l| l.strip }
@neg_post_comments = File.readlines("#{Rails.root}/app/assets/text_files/p_com_neg.txt").map! { |l| l.strip }
# food
@p_comms_pos_food = File.readlines("#{Rails.root}/app/assets/text_files/p_comms_pos_food.txt").map! { |l| l.strip }
@p_comms_neg_food = File.readlines("#{Rails.root}/app/assets/text_files/p_comms_neg_food.txt").map! { |l| l.strip }

def get_comment_body(is_positive, type)
  if is_positive
    if type == 'arch'
      @pos_post_comments.sample
    else
      @p_comms_pos_food.sample
    end
  else
    if type == 'arch'
      @neg_post_comments.sample
    else
      @p_comms_neg_food.sample
    end
  end
end


def random_avatar
  Rack::Test::UploadedFile.new(
    Dir.glob("#{Rails.root}/app/assets/images/user_avatars/*.jpeg").sample,
    'jpeg')
end

def random_picture(type)
  if type == 'arch'
    path = Dir.glob("#{Rails.root}/app/assets/images/post_pictures/*.jpeg").sample
  else
    path = Dir.glob("#{Rails.root}/app/assets/images/post_pics_food/*.jpeg").sample
  end
  title = path.split('/')[-1].split('_')[0..-3].join(' ')
  [
    Rack::Test::UploadedFile.new(path, 'jpeg'),
    title
  ]
end

def create_stories(user)
  min = 3
  max = 15
  rand(min..max).times do
    title = random_picture('arch')[1]
    user.stories.create!(
      title: title,
      description: @pos_post_descriptions.sample
    )
  end
end

def create_posts(user)
  post_count = rand(24..60)
  p "number of posts - #{post_count}"
  post_count.times do
    is_positive = rand(1..10) > 3
    type = ['arch', 'food'].sample
    picture = random_picture(type)
    body = get_post_body(is_positive, type)
    post = user.posts.create!(
      body: "#{picture[1]} #{body}",
      picture: picture[0]
    )
    create_comments(post, is_positive, type)
  end
end

def create_comments(post, is_positive, type)
  min = 0
  max = 15
  rand(min..max).times do
    c_body = get_comment_body(is_positive, type)
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
