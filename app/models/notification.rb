class Notification < ApplicationRecord
  belongs_to :notification_manager
  delegate :user, to: :notification_manager
  before_create :set_data

  def thing_connected
    info = self.notification_type.split(',')
    thing = info[2].classify.constantize.find(info[1].to_i)
    info[0] == 'comment_liked' ? thing.post : thing
  end

  private

  def set_data
    info = self.notification_type.split(',')
    self.data = case info[0]
                when 'story_liked'
                  "Your story has a new like"
                when 'post_commented'
                  "Your post has a new comment"
                when 'post_liked'
                  "Your post has a new like"
                when 'comment_liked'
                  "Your comment has a new like"
                when 'observed_stories'
                  "User you observe made a new story"
                when 'observed_posts'
                  "User you observe made a new post"
                else
                  'Something went wrong.'
                end
  end

end
