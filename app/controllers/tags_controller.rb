class TagsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @tags = Tag.all.order('name ASC')
  end

  def search
    @tags = Tag.all.order('name ASC')
    respond_to(&:turbo_stream)
  end
end
