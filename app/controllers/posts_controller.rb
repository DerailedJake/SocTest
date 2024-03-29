class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show display_posts]
  before_action :set_user, only: [:display_posts]
  before_action :set_user_posts, only: [:display_posts]
  def new
    @post = params[:post] ? Post.new(post_params) : Post.new
    @story_to_redirect = params[:story_to_redirect]
  end

  def display_posts; end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @pagy_stories, @stories = pagy(@post.stories, items: 3)
    @comments = @post.comments.page(1).per(12)
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      flash[:success] = "Post created!"
      redirect_to post_redirect
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
      flash[:success] = "Post updated!"
      redirect_to post_redirect
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

  def post_redirect
    story = params[:post][:story_to_redirect]
    story.empty? ? @post : current_user.stories.find(story)
  end

  def post_params
    params.require(:post).permit(:picture, :body, { story_ids: []}).merge({ tag_ids: params[:tag_ids] })
  end
end
