class NotificationManager < ApplicationRecord
  belongs_to :user
  has_many :notifications
  before_create :set_settings

  private

  def set_settings
    self.settings = [
      { stories: true },
      { posts: true },
      { comments: true },
      { likes: true },
      { observed_stories: true },
      { observed_posts: true }
    ].to_json
  end
end
