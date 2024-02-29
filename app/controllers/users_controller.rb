class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :profile]

  def index
    @users = User.all
  end

  def profile
    @user = User.includes(posts: :picture_attachment).find(params[:id])
    @stories = @user.stories
    @posts = user_posts(@user.id)
  end

  def home
    @stories = current_user.stories
    @posts = user_posts(current_user.id)
  end
end
