class ApplicationController < ActionController::Base
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
    @posts = @user.posts.order('created_at DESC').with_attached_picture
                  .page(params[:page] || 1).per(3) || []
  end

  def set_user_stories
    @stories = @user.stories.order('created_at DESC').page(params[:page] || 1).per(3) || []
  end
end
