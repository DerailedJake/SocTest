class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true, counter_cache: :likes_count
  after_create :notify

  def notify
    u = likeable.user
    type = "#{likeable_type.underscore}_liked"
    if likeable.class.name == 'Comment'
      u.notification_manager.notify(type, likeable.post)
    else
      u.notification_manager.notify(type, likeable)
    end
  end
end
