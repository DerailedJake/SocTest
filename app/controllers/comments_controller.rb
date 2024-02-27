class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.new(comment_params)
    respond_to do |format|
      if @comment.save
        flash[:success] = "Comment created!"
        format.js   {}
        format.json { render json: @comment, status: :created, location: @comment }
      else
        flash[:danger] = @comment.errors.full_messages.first
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
