class Tag < ApplicationRecord
  has_many :taggings, as: :taggable
  has_many :posts, through: :taggings, source: :taggable, source_type: 'Post'
  has_many :stories, through: :taggings, source: :taggable, source_type: 'Story'

  validates :name, presence: true, length: { minimum: 1, maximum: 20 }, uniqueness: true
end
