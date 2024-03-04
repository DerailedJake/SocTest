class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :set_user, only: [:index]
  before_action :set_user_posts, only: [:index]
  def new
    p params
    @post = params[:post] ? Post.new(post_params) : Post.new
    @story_to_redirect = params[:story_to_redirect]
  end

  def index
    respond_to do |format|
      format.js
    end
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @stories = @post.stories.page(1).per(3)
    @comments = @post.comments.page(1).per(12)
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
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post)
    else
      flash[:danger] = @post.errors.full_messages.first
      redirect_to edit_post_path(@post)
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    if @post.destroy
      flash[:success] = 'Post removed'
      redirect_to root_path
    else
      flash[:danger] = @post.errors.full_messages.first
      redirect_to edit_post_path(@post)
    end
  end

  private

  def post_params
    params.require(:post).permit(:picture, :body, { story_ids: []})
  end

end
