class CommentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @post = Post.find(params[:post_id])
    @pagy_comments, @comments = pagy(@post.comments.includes(user: :avatar_attachment)
                                          .order("created_at DESC"), items: 5)
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

  def edit
    @comment = current_user.comments.find(params[:id])
  end

  def update
    @comment = current_user.comments.find(params[:id])
    if @comment.update(comment_params)
      flash.now[:success] = 'Comment updated!'
    else
      flash.now[:danger] = @post.errors.full_messages.first
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    if @comment.destroy
      flash.now[:success] = 'Comment deleted!'
    else
      flash.now[:danger] = @post.errors.full_messages.first
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :post_id)
  end
end
