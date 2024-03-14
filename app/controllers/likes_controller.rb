class LikesController < ApplicationController

  def like
    @like = current_user.likes.find_by(like_params)
    if @like
      @like.destroy
    else
      @like = current_user.likes.new(like_params)
      @like.save
    end
    respond_to(&:turbo_stream)
  end

  def liked
    @likes = current_user.likes
  end

  def liked_things
    @thing = params[:thing]
    @pagy_likeable, @likeables = pagy(current_user.likes.includes(:likeable).where(likeable_type: @thing), items: 3)
    @likeables = @likeables.map(&:likeable)
  end

  private

  def like_params
    params.require(:like).permit(:likeable_id, :likeable_type)
  end
end
