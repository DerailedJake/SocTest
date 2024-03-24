class Story < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :posts
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  validates :title, presence: true, length: { minimum: 1, maximum: 80 }
  validate :validate_posts_belong_to_user
  after_create :notify

  def notify
    users = Contact.where(acquaintance_id: user.id)
    return if users.empty?
    users.each do |u|
      u.notification_manager.notify('observed_stories', self)
    end
  end

  private

  def validate_posts_belong_to_user
    (return if posts.all? { |post| post.user == user })
    errors.add(:base, 'Posts must belong to the same user as the story')
  end
end
