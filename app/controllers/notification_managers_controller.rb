class NotificationManagersController < ApplicationController

  def index
    @pagy_notifications, @notifications = pagy_array(current_user.notifications.order('created_at DESC'), items: 12)
    @notifications = @notifications
  end

  def update
    @manager = current_user.notification_manager
    @manager.settings_data_from_params(params[:settings])
    if @manager.save
      flash[:info] = 'Settings changed'
    else
      flash[:danger] = 'Failed to change settings'
    end
    redirect_to notification_options_path
  end

  def options
    @manager = current_user.notification_manager
  end
end
