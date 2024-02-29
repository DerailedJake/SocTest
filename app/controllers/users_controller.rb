class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :profile]
  before_action :set_user, only: [:profile, :home]
  before_action :set_user_posts, only: [:profile, :home]
  before_action :set_user_stories, only: [:profile, :home]

  def index
    @users = User.all
  end

  def profile
    @user = User.includes(posts: :picture_attachment).find(params[:id])
  end

  def home
  end
end
