class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys:  [:username, :email, :avatar])
  end

  private

  def user_posts
    @posts = User.find(params[:user_id] || current_user.id).posts.with_attached_picture
             .includes({ comments: { user: { avatar_attachment: :blob } } })
             .page(params[:page] || 1).per(3) || []
  end

end
