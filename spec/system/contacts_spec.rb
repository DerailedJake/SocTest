require 'rails_helper'

RSpec.describe 'Contact', type: :system do
  before do
    @current_user = user_with_posts_and_stories
    create_list(:user, 7)
    @second_user = User.second
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
          User.all.each do |user|
            next if user == @current_user
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
end
