class PostsController < ApplicationController
  def new
    p params
    @post = params[:post] ? Post.new(post_params) : Post.new
    @story_to_redirect = params[:story_to_redirect]
  end

  def index
    respond_to do |format|
      format.js
      format.html
    end
    @posts = user_posts(params[:user_id])
  end

  def create
    @post = current_user.posts.new(post_params)
    @story_to_redirect = params[:post][:story_to_redirect]
    if @post.save
      flash[:success] = "Post created!"
      if @story_to_redirect
        redirect_to story_path(current_user.stories.find(@story_to_redirect))
      else
        redirect_to root_path
      end
    else
      flash[:danger] = @post.errors.full_messages.first
      render 'new', status: 422
    end
  end

  def edit
  end

  private

  def post_params
    params.require(:post).permit(:picture, :body, { story_ids: []})
  end

end
