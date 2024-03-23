class Notification < ApplicationRecord
  belongs_to :notification_manager

  delegate :user, to: :notification_manager


end
