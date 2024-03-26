class Comment < ApplicationRecord
  validates :body, presence: true, length: { minimum: 1, maximum: 150 }
  belongs_to :user
  belongs_to :post
  has_many :likes, as: :likeable, dependent: :destroy
  after_create :notify

  def notify
    return if post.user == user
    post.user.notification_manager.notify('post_commented', post)
  end
end
