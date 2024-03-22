class StoriesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show index display_stories timeline]
  before_action :set_user, only: [:display_stories]
  before_action :set_user_stories, only: [:display_stories]

  def show
    @story = Story.includes(user: :avatar_attachment).find(params[:id])
    @pagy_posts, @posts = pagy(@story.posts.with_attached_picture, items: 1)
  end
  def new
    @story = current_user.stories.new
    @posts = current_user.posts
  end
  def timeline
    @story = Story.find(params[:story_id])
    @pagy_posts, @posts = pagy(@story.posts, items: 1)
  end

  def display_stories
    return unless params[:post_id]

    @post = Post.find(params[:post_id])
    @in_post_view = true
    @pagy_stories, @stories = pagy(@post.stories.order('created_at ASC'),
                                   items: 3, page_param: :page_stories)
  end

  def index
    @stories = Story.order('RANDOM()').includes(:user, :tags).limit(9)
  end

  def create
    @story = current_user.stories.new(stories_params)
    if @story.save
      flash[:success] = "Story created!"
      redirect_to story_path(@story)
    else
      flash[:danger] = @story.errors.full_messages.first
      render 'new', status: 422
    end
  end

  def edit
    @story = current_user.stories.find(params[:id])
    @posts = current_user.posts
  end

  def update
    @story = current_user.stories.find(params[:id])
    if @story.update(stories_params)
      flash[:success] = 'Story updated!'
      redirect_to story_path(@story)
    else
      flash[:danger] = @story.errors.full_messages.first
      redirect_to edit_story_path(@story)
    end
  end

  def destroy
    @story = current_user.stories.find(params[:id])
    if @story.destroy
      flash[:success] = 'Story deleted!'
      redirect_to root_path
    else
      flash[:danger] = @story.errors.full_messages.first
      redirect_to story_path(@story)
    end
  end

  private

  def stories_params
    params.require(:story).permit(:title, :description, { post_ids: [] }).merge({ tag_ids: params[:tag_ids] })
  end
end
