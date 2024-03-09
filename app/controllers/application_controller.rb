class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name description username email avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name description username email avatar])
  end

  private

  def set_user
    @user = User.find(params[:user_id] || params[:id] || current_user.id)
  end
  def set_user_posts
    @pagy_posts, @posts = pagy(@user.posts.order('created_at DESC').with_attached_picture, items: 3)
  end

  def set_user_stories
    @pagy_stories, @stories = pagy(@user.stories.order('created_at DESC'), items: 3)
  end
end
