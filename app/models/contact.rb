class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :acquaintance, class_name: 'User', foreign_key: :acquaintance_id
  validates :status, presence: true, inclusion: %w[observed]
end
