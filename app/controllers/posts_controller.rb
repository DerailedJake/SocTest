class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      flash[:success] = "Post created!"
      redirect_to root_path
    else
      flash[:danger] = @post.errors.full_messages.first
      render 'new', status: 422
    end
  end

  def edit
  end

  private

  def post_params
    params.require(:post).permit(:picture, :body)
  end

end
