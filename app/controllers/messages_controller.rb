class MessagesController < ApplicationController

  def older_messages
    @chat = current_user.chats.find(params[:chat_id])
    @messages = nil
    if @chat
      @pagy_messages, @messages = pagy(@chat.messages.reverse_order, items: 8)
      @messages = @messages.reverse
    end
    respond_to(&:turbo_stream)
  end

  def send_message
    @chat = current_user.chats.find(params[:chat_id])
    @message = current_user.messages.new(chat: @chat, content: params[:content])
    unless @message.save
      flash.now[:danger] = 'Failed to send message'
      render nil
    end
    respond_to(&:turbo_stream)
  end
end
