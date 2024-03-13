module ApplicationHelper
  include Pagy::Frontend

  include Pagy::Backend
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def render_turbo_flashes
    turbo_stream.update "flashes", partial: "shared/flashes"
  end
end
