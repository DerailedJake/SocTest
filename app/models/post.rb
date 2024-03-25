class Post < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :stories
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  has_one_attached :picture
  validates :body, presence: true, length: { minimum: 3, maximum: 500 }
  validate :stories_belong_to_user
  after_create :notify

  def notify
    contacts = Contact.where(acquaintance_id: user.id)
    return if contacts.empty?
    contacts.each do |contact|
      contact.user.notification_manager.notify('observed_posts', self)
    end
  end

  def short_description
    body.truncate(30)
  end

  def stories_belong_to_user
    (return if stories.all? { |story| story.user == user })
    errors.add(:base, 'Stories must belong to the same user as the post')
  end
end
