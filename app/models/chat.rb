class Chat < ApplicationRecord
  has_many :messages
  has_many :chat_participations, dependent: :destroy
  has_many :users, through: :chat_participations
end
