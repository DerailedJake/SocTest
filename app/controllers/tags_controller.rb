class TagsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @tags = Tag.all.order('name ASC')
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
