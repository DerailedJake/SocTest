class Story < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { minimum: 4, maximum: 40 }
  has_and_belongs_to_many :posts
end
