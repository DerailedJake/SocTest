class Post < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :stories
  validates :body, presence: true, length: { minimum: 10 }
  has_one_attached :picture
  has_many :comments, dependent: :destroy

  def short_description
    body.truncate(30)
  end

  def latest_comments
    comments.order("created_at DESC").includes(user: :avatar_attachment).page(1).per(3)
  end
end
