class NotificationManagersController < ApplicationController

  def index
    @notifications = current_user.notifications
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
