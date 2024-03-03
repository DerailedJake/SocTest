class Comment < ApplicationRecord
  validates :body, presence: true, length: { minimum: 1, maximum: 150 }
  belongs_to :user
  belongs_to :post
end
