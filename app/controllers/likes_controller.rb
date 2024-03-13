class LikesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @like = Like.new(like_params)
    @likeable = @like.likeable
  end

  def create
    if current_user.likes.find_by(like_params)
      @like = current_user.likes.find_by(like_params)
      if @like.destroy
        flash.now[:success] = 'Fuck 1'
      else
        flash.now[:danger] = 'No fuck 1'
      end
    else
      @like = current_user.likes.new(like_params)
      if @like.save
        flash.now[:success] = 'Fuck 2'
      else
        flash.now[:danger] = 'No fuck 2'
      end
    end
    respond_to(&:turbo_stream)
  end

  private

  def like_params
    params.require(:like).permit(:likeable_id, :likeable_type)
  end
end
