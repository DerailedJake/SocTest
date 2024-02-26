class Post < ApplicationRecord
  belongs_to :user
  belongs_to :story
  validates :body, presence: true, length: { minimum: 10 }
  has_one_attached :picture
  def short_description
    body.truncate(30)
  end
end
