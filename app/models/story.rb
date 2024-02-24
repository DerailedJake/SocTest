class Story < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { minimum: 4, maximum: 40 }
  has_many :posts
end
