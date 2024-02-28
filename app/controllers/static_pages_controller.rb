class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!
  def landing
    @users = User.order('RANDOM()').limit(3)
    @posts = Post.order('RANDOM()').limit(3)
  end

  def about
  end

  def contact
  end

  def legal
  end
end
