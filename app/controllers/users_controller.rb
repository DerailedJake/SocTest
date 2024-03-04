class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :profile]
  before_action :set_user, only: [:profile, :home]
  before_action :set_user_posts, only: [:profile, :home]
  before_action :set_user_stories, only: [:profile, :home]

  def index
    @users = User.all.order('created_at ASC').with_attached_avatar.page(params[:page] || 1).per(6) || []
    respond_to do |format|
      format.html
      format.js
    end
  end

  def profile
  end

  def home
  end
end
