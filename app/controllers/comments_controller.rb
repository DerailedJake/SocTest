class CommentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @post = Post.find(params[:post_id])
    @pagy_comments, @comments = pagy(@post.comments.includes(user: :avatar_attachment).order("created_at DESC"), items: 3)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def create
    @comment = current_user.comments.new(comment_params)
    respond_to do |format|
      if @comment.save
        flash.now[:success] = "Comment created!"
        format.js   {}
        format.json { render json: @comment, status: :created, location: @comment }
      else
        flash.now[:danger] = @comment.errors.full_messages.first
        format.js   {}
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
  end

  def destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :post_id)
  end
end
