class ContactsController < ApplicationController

  def index
    @pagy_users, @users = pagy(current_user.acquaintances, items: 6)
  end

  def observe
    @user = User.find(params[:user_id])
    @contact = current_user.contacts.find_by(acquaintance: @user)
    if @contact
      @contact.destroy
    else
      @contact = current_user.contacts.new(acquaintance: @user)
      @contact.save
    end
    respond_to(&:turbo_stream)
  end

  def contacts_panel
    return if params[:collapse]
    @contacts = current_user.contacts.includes(acquaintance: :avatar_attachment)
  end
end
