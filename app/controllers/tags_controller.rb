class TagsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @tags = params[:sort_by] == 'alphabetically' ? Tag.all.order('name ASC') : Tag.all.order('taggable_count DESC')
  end

  def show
    @tag = Tag.find_by(name: params[:name])
    @pagy_posts, @posts = pagy(@tag.posts, items: 3, page_param: :post_page)
    @pagy_stories, @stories = pagy(@tag.stories, items: 3, page_param: :story_page)
  end

  def search
    @tags = Tag.filter_by_name(params[:tag_name])
    respond_to(&:turbo_stream)
  end

  def add_tag_to_thing
    @tag = Tag.find_by(name: params[:name])
    respond_to(&:turbo_stream)
  end
end
