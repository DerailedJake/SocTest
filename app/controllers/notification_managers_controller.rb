class NotificationManagersController < ApplicationController

  def options
    @manager = current_user.notification_manager
  end
end
