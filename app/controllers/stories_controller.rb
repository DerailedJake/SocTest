class StoriesController < ApplicationController

  def show
    @story = Story.find(params[:id])
  end
  def new
    @story = Story.new(user: current_user)
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
    @story = current_user.stories.find_by(params[:id])
    if @story.update_attributes(stories_params)
      flash[:success] = "Story updated!"
      redirect_to story_path(@story)
    else
      flash[:danger] = @story.errors.full_messages.first
      render 'edit', status: 422
    end
  end

  def delete; end

  private

  def stories_params
    params.require(:story).permit(:title, :description)
  end
end
