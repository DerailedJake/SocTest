class CommentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :set_comment, only: %i[edit update destroy]

  def index
    @post = Post.find(params[:post_id])
    @pagy_comments, @comments = pagy(@post.comments.includes(user: :avatar_attachment)
                                          .order("created_at DESC"), items: 5)
  end

  def create
    @comment = current_user.comments.new(comment_params)
    @post = @comment.post
    if @comment.save
      flash.now[:success] = "Comment created!"
    else
      flash.now[:danger] = @comment.errors.full_messages.first
    end
    respond_to(&:turbo_stream)
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      flash.now[:success] = 'Comment updated!'
    else
      @comment.reload
      flash.now[:danger] = @comment.errors.full_messages.first
    end
  end

  def destroy
    if @comment.destroy
      flash.now[:success] = 'Comment deleted!'
    else
      flash.now[:danger] = @post.errors.full_messages.first
    end
    respond_to(&:turbo_stream)
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :post_id)
  end

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end
end
