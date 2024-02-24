class StoriesController < ApplicationController
  def new
    @story = Story.new(user: current_user)
  end

  def create
    @story = current_user.stories(stories_params)
    if @story.save
      flash[:success] = "Story created!"
      redirect_to story_path(@story)
    else
      flash[:danger] = @story.errors.full_messages.first
      render 'new', status: 422
    end
  end

  def edit; end

  def update; end

  def delete; end

  private

  def stories_params
    params.require(:story).permit(:title, :description)
  end
end
