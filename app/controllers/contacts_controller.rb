class ContactsController < ApplicationController

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
end
