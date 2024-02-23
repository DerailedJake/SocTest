class Post < ApplicationRecord
  belongs_to :user
  validates :body, presence: true, length: { minimum: 10 }
  has_one_attached :picture
end
