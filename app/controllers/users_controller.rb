class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :profile]
  before_action :user_posts, only: [:profile, :home]

  def index
    @users = User.all
  end

  def profile
    @user = User.includes(posts: :picture_attachment).find(params[:id])
    @stories = @user.stories
  end

  def home
    @stories = current_user.stories
  end
end
