class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :profile]

  def index
    @users = User.all
  end

  def profile
    @user = User.includes(posts: :picture_attachment).find(params[:id])
    @stories = @user.stories
  end

  def home
    @posts = current_user.posts.with_attached_picture
                         .includes({ comments: { user: { avatar_attachment: :blob } } }) | []

    @stories = current_user.stories
  end
end
