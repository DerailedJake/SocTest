class StoriesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show index user_stories timeline]
  before_action :set_user, only: [:user_stories]
  before_action :set_user_stories, only: [:user_stories]

  def show
    @story = Story.includes(user: :avatar_attachment).find(params[:id])
    @posts = @story.posts.with_attached_picture
  end
  def new
    @story = Story.new(user: current_user)
  end

  def timeline
    @page = params[:page] || 1
    @page = @page.to_i
    @story = Story.find(params[:story_id])
    @total_pages = @story.posts.page(@page).per(1).total_pages
    @posts = @story.posts.page(@page).per(1)
  end

  def user_stories
    respond_to do |format|
      format.js
    end
  end

  def index
    @stories = Story.order('RANDOM()').limit(9)
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
      redirect_to story_path(@story)
    else
      flash[:danger] = @story.errors.full_messages.first
      redirect_to edit_story_path(@story)
    end
  end

  def delete; end

  private

  def stories_params
    params.require(:story).permit(:title, :description, { post_ids: [] })
  end
end
