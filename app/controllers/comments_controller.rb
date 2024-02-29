class CommentsController < ApplicationController

  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments.order("created_at DESC")
                              .page(params[:page] || 1).per(3)
    respond_to do |format|
      format.js
    end
  end

  def create
    @comment = current_user.comments.new(comment_params)
    respond_to do |format|
      if @comment.save
        flash[:success] = "Comment created!"
        format.js   {}
        format.json { render json: @comment, status: :created, location: @comment }
      else
        flash.now[:danger] = @comment.errors.full_messages.first
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
