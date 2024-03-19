class MessagesController < ApplicationController

  def send_message
    @chat = current_user.chats.find(params[:chat_id])
    @message = current_user.messages.new(chat: @chat, content: params[:content])
    if @message.save
    else
      flash.now[:danger] = 'Failed to send message'
      render nil
    end
    respond_to(&:turbo_stream)
  end
end
