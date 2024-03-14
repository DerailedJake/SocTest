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
    @likes = current_user.likes.where(likeable_type: @thing)
    # fix this later
    # @likeables = current_user.likes.includes(:likeable).select{|l| l.likeable if l.likeable_type == 'Story'}
    if @thing == 'Story'
      @thing_name = 'Stories'
      @likeables = Story.joins(:likes).where(likes: {user_id: current_user.id})
    elsif @thing == 'Post'
      @thing_name = 'Posts'
      @likeables = Post.joins(:likes).where(likes: {user_id: current_user.id})
    end
    @pagy_likeable, @likeables = pagy(@likeables, items: 3, page_param: :page_stories)
  end

  private

  def like_params
    params.require(:like).permit(:likeable_id, :likeable_type)
  end
end
