class Comment < ApplicationRecord
  validates :body, presence: true, length: { maximum: 150 }
  belongs_to :user
end
