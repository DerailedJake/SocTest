class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat
  validates :content, presence: true, length: { minimum: 1, maximum: 500 }

  after_create_commit :broadcast_message

  private

  def broadcast_message
    broadcast_append_to("chat-#{chat.id}", target: "turbo-chat-inside",
                        partial: 'messages/message', locals: { scroll_down: true })
  end
end
