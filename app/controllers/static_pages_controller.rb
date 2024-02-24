class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!
  def landing
    @users = [User.first, User.second, User.last]
  end

  def about
  end

  def contact
  end

  def legal
  end
end
