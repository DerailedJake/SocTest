class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :profile]

  def index
    @users = User.all
  end

  def profile
    @user = User.find(params[:id])
  end

  def home
    @posts = current_user.posts | []
  end
end
