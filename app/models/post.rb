class Post < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :stories
  has_many :comments, dependent: :destroy
  has_one_attached :picture
  validates :body, presence: true, length: { minimum: 3, maximum: 500 }
  validate :stories_belong_to_user

  def short_description
    body.truncate(30)
  end

  def latest_comments(number_of_comm = 3)
    comments.order("created_at DESC").includes(user: :avatar_attachment).page(1).per(number_of_comm)
  end

  def stories_belong_to_user
    (return if stories.all? { |story| story.user == user })
    errors.add(:base, 'Stories must belong to the same user as the post')
  end
end
