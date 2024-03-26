class Notification < ApplicationRecord
  belongs_to :notification_manager
  delegate :user, to: :notification_manager
  before_create :set_data

  def link
    data.split(';')[1]
  end

  def message
    data.split(';')[0]
  end

  private

  def set_data
    info = notification_type.split(',')
    self.data = case info[0]
                when 'story_liked'
                  "Your story has a new like;stories/#{info[1]}"
                when 'post_commented'
                  "Your post has a new comment;posts/#{info[1]}"
                when 'post_liked'
                  "Your post has a new like;posts/#{info[1]}"
                when 'comment_liked'
                  "Your comment has a new like;posts/#{info[1]}"
                when 'observed_stories'
                  "User you observe made a new story;stories/#{info[1]}"
                when 'observed_posts'
                  "User you observe made a new post;posts/#{info[1]}"
                else
                  'Something went wrong.'
                end
  end

end
