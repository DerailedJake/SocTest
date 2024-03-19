class ChatsController < ApplicationController

  def index
    @chats = current_user.chats
    respond_to(&:turbo_stream)
  end

  def direct_chat
    @user = User.find(params[:user_id])
    # nil if current_user == @user
    @chat = current_user.chats.joins(:users).where(users: @user.id).first
    unless @chat
      @chat = Chat.create(title: 'Direct chat', user_ids: [current_user.id, @user.id])
    end
    respond_to(&:turbo_stream)
  end
end
