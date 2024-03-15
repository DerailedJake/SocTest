class Story < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :posts
  has_many :likes, as: :likeable, dependent: :destroy
  validates :title, presence: true, length: { minimum: 1, maximum: 80 }
  validate :validate_posts_belong_to_user


  private

  def validate_posts_belong_to_user
    (return if posts.all? { |post| post.user == user })
    errors.add(:base, 'Posts must belong to the same user as the story')
  end
end
