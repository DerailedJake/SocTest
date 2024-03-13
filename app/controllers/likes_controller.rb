class LikesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @like = Like.new(like_params)
    @likeable = @like.likeable
    @liked = current_user && current_user.likes.find_by(like_params) ? false : true
  end

  def create
    if current_user.likes.find_by(like_params)
      @like = current_user.likes.find_by(like_params)
      @like.destroy
    else
      @like = current_user.likes.new(like_params)
      @like.save
    end
    respond_to(&:turbo_stream)
  end

  private

  def like_params
    params.require(:like).permit(:likeable_id, :likeable_type)
  end
end
