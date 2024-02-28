class Story < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { minimum: 1, maximum: 80 }
  has_and_belongs_to_many :posts
end
