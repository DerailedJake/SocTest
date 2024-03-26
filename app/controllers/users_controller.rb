class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :profile]
  before_action :set_user, only: [:profile, :home]

  def index
    @pagy_users, @users = pagy(User.public_users.order('created_at ASC').with_attached_avatar, items: 6)
  end

  def profile; end

  def home; end
end
