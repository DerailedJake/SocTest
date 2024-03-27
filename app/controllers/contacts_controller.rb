class ContactsController < ApplicationController
  before_action :set_contact, only: %i[invite accept_invite cancel_invite]

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

  def manage_contacts
    @pagy_contacts, @contacts = pagy(current_user.contacts.includes(acquaintance: :avatar_attachment), items: 10)
  end

  def invite
    if @contact.invite
      flash[:success] = 'Invitation sent'
    else
      flash[:danger] = 'Something went wrong'
    end
    redirect_to manage_contacts_path
  end

  def accept_invite
    if @contact.accept_invitation
      flash[:success] = 'Invitation accepted'
    else
      flash[:danger] = 'Something went wrong'
    end
    redirect_to manage_contacts_path
  end

  def cancel_invite
    if @contact.cancel_invitation
      flash[:success] = 'Invitation canceled'
    else
      flash[:danger] = 'Something went wrong'
    end
    redirect_to manage_contacts_path
  end

  def remove_friend
    if @contact.remove_friend
      flash[:success] = 'Contact is no longer a friend'
    else
      flash[:danger] = 'Something went wrong'
    end
    redirect_to manage_contacts_path
  end

  def block

  end

  def un_block

  end


  private

  def set_contact
    @contact = current_user.contacts.find_by(acquaintance_id: params[:user_id])
  end
end
