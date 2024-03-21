class ChatsChannel < ApplicationCable::Channel
  def subscribed
    @chat = Chat.find(params[:chat_id])
    reject unless @chat.users.includes(current_user)
    stream_from "chat-#{@chat.id}"
  end
end
