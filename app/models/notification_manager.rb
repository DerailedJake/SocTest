class NotificationManager < ApplicationRecord
  belongs_to :user
  has_many :notifications
  before_create :default_data

  def settings
    JSON.parse(settings_data)
  end

  def reset_settings
    update(settings_data: default_data)
  end

  private

  def default_data
    self.settings_data = {
      story_commented: true,
      story_liked: true,
      post_commented: true,
      post_liked: true,
      comments_liked: true,
      observed_stories: true,
      observed_posts: true
    }.to_json
  end
end
