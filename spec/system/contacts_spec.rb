require 'rails_helper'

RSpec.describe 'Contact', type: :system do
  before do
    @current_user = user_with_posts_and_stories
    @users = create_list(:user, 7)
    @second_user = @users.first
  end

  describe 'side panel' do
    context 'open and collapse' do
      before do
        login_as @current_user
        visit static_pages_about_path
      end
      it 'should work properly' do
        expect(page).to have_content 'Contacts'
        click_on 'Contacts'
        within '#side-panel' do
          expect(page).to have_content 'You have no contacts yet'
        end
        click_on 'Contacts'
        expect(page).not_to have_selector '#side-panel'
        expect(page).to have_current_path static_pages_about_path
      end
    end
    context 'when logged IN' do
      before do
        login_as @current_user
        visit static_pages_about_path
      end
      context 'with no people' do
        it 'shows empty panel' do
          expect(page).to have_content 'Contacts'
          click_on 'Contacts'
          within '#side-panel' do
            expect(page).to have_content 'You have no contacts yet'
          end
        end
      end
      context 'with people' do
        before do
          @users.each do |user|
            @current_user.contacts.create!(acquaintance: user)
          end
        end
        it 'shows contacts' do
          expect(page).to have_content 'Contacts'
          click_on 'Contacts'
          within '#side-panel' do
            expect(page).to have_content @users.first.full_name
            expect(page).to have_content @users.last.full_name
          end
        end
        it 'has working links' do
          expect(page).to have_content 'Contacts'
          click_on 'Contacts'
          within '#side-panel' do
            expect(page).to have_content @second_user.full_name
            click_on @second_user.full_name
          end
          expect(page).to have_current_path profile_path @second_user
        end
      end
    end
    context 'when logged OUT' do
      it 'it does not show side panel' do
        visit static_pages_about_path
        expect(page).not_to have_content 'Contacts'
        expect(page).not_to have_selector '#side-panel'
      end
    end
  end

  describe 'observing people' do
    context 'while logged IN' do
      before do
        login_as @current_user
      end
      context 'on your own profile' do
        it 'does not show eye' do
          visit profile_path @current_user
          expect(page).not_to have_selector '#user-observe'
        end
      end
      context 'on another profile' do
        it 'observes a person' do
          visit profile_path @second_user
          expect(@current_user.acquaintances.include?(@second_user)).to eq false
          expect(page).to have_selector '#user-observe'
          click_on 'user-observe'
          expect(page).to have_selector '.bi-eye-fill'
          expect(@current_user.acquaintances.include?(@second_user)).to eq true
        end
      end
      context 'contacts index' do
        before do
          @users.each do |user|
            @current_user.contacts.create!(acquaintance: user)
          end
        end
        it 'shows observed people' do
          visit observed_path
          expect(page).to have_content @second_user.full_name
          click_on '2'
          expect(page).to have_content User.last.full_name
        end
      end
    end
    context 'while logged OUT' do
      it 'does not show eye' do
        visit profile_path @current_user
        expect(page).not_to have_selector '#user-observe'
        visit profile_path @second_user
        expect(page).not_to have_selector '#user-observe'
      end
      it 'does not show index' do
        visit static_pages_about_path
        expect(page).not_to have_content 'Observed'
        visit observed_path
        expect(page).to have_current_path new_user_session_path
      end
    end
  end

  describe 'inviting and befriending -' do
    context 'sending invitation' do
      before do
        login_as @current_user
        @current_user.contacts.create(acquaintance: @second_user)
      end
      it 'works properly' do
        visit manage_contacts_path
        expect(page).to have_content @second_user.full_name
        click_on 'Invite'
        expect(page).to have_content 'Invitation sent'
        expect(page).to have_content 'Cancel invitation'
        expect(Contact.all.pluck(:status)).to eql(%w[was_invited invited])
      end
    end
    context 'receiving and accepting invitation' do
      before do
        login_as @current_user
        contact = @second_user.contacts.create(acquaintance: @current_user)
        contact.invite
      end
      it 'works properly' do
        visit manage_contacts_path
        expect(page).to have_content @second_user.full_name
        click_on 'Accept invitation'
        expect(page).to have_content 'Invitation accepted'
        expect(page).to have_content @second_user.full_name
        expect(Contact.all.pluck(:status)).to eql(%w[befriended befriended])
      end
    end
    context 'cancelling invitation' do
      before do
        login_as @current_user
        contact = @current_user.contacts.create(acquaintance: @second_user)
        contact.invite
      end
      it 'works properly' do
        visit manage_contacts_path
        expect(page).to have_content @second_user.full_name
        cancel_invitation
        expect(page).to have_content @second_user.full_name
        expect(page).to have_content 'Invite'
        expect(Contact.all.pluck(:status)).to eql(%w[stranger])
      end
      it 'removes unobserved contact' do
        @current_user.contacts.first.update!(observed: nil)
        visit manage_contacts_path
        expect(page).to have_content @second_user.full_name
        cancel_invitation
        expect(page).to have_content 'You have no contacts yet'
        expect(Contact.count).to eql(0)
      end
    end
    context 'removing a friend' do
      before do
        login_as @current_user
        @current_user.contacts.create(acquaintance: @second_user, status: 'befriended')
        @second_user.contacts.create(acquaintance: @current_user, status: 'befriended')
      end
      it 'works properly' do
        visit manage_contacts_path
        expect(Contact.count).to eql(2)
        expect(page).to have_content @second_user.full_name
        remove_friend
        expect(page).to have_content @second_user.full_name
        expect(page).to have_content 'Invite'
        expect(Contact.all.pluck(:status)).to eql(%w[stranger stranger])
      end
      it 'removes unobserved contact' do
        @current_user.contacts.first.update!(observed: nil)
        @second_user.contacts.first.update!(observed: nil)
        visit manage_contacts_path
        expect(Contact.count).to eql(2)
        expect(page).to have_content @second_user.full_name
        remove_friend
        expect(page).to have_content 'You have no contacts yet'
        expect(Contact.count).to eql(0)
      end
    end
  end

  describe 'blocking -' do
    context 'someone else' do
      before do
        login_as @current_user
        @current_user.contacts.create(acquaintance: @second_user)
      end
      it 'works properly' do
        visit manage_contacts_path
        expect(page).to have_content @second_user.full_name
        click_on 'Block'
        accept_alert
        expect(page).to have_content 'User is blocked'
        expect(page).to have_content 'Unblock'
        expect(Contact.all.pluck(:status)).to eql(%w[was_blocked blocked])
      end
    end
    context 'getting blocked' do
      before do
        login_as @current_user
        @current_user.contacts.create(acquaintance: @second_user)
        @second_user.contacts.create(acquaintance: @current_user)
      end
      it 'works properly' do
        visit manage_contacts_path
        expect(page).to have_content @second_user.full_name
        @second_user.contacts.first.block
        visit manage_contacts_path
        expect(page).not_to have_content @second_user.full_name
        expect(Contact.all.pluck(:status)).to eql(%w[was_blocked blocked])
      end
    end
  end

  def cancel_invitation
    click_on 'Cancel invitation'
    expect(page).to have_content 'Invitation canceled'
  end

  def remove_friend
    click_on 'Remove friend'
    accept_alert
    expect(page).to have_content 'User is no longer a friend'
  end
end
