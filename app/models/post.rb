class Post < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :stories
  validates :body, presence: true, length: { minimum: 10 }
  has_one_attached :picture
  has_many :comments, dependent: :destroy
  def short_description
    body.truncate(30)
  end
end
