class Tag < ApplicationRecord
  has_many :taggings, as: :taggable
  has_many :posts, through: :taggings, source: :taggable, source_type: 'Post'
  has_many :stories, through: :taggings, source: :taggable, source_type: 'Story'

  scope :filter_by_name, ->(name) { where('name ILIKE ?', "%#{name}%").limit(6) }

  validates :name, presence: true, length: { minimum: 1, maximum: 20 }, uniqueness: true

end
