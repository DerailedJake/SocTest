require 'rails_helper'

RSpec.describe 'NotificationManagers', type: :system do
  before do
    @current_user = user_with_posts_and_stories
    login_as @current_user
  end

  describe 'change options' do
    it 'renders settings page' do
      visit notification_options_path
      expect(page).to have_content 'Notification Options:'
    end
    it 'properly updates settings' do
      visit notification_options_path
      uncheck 'settings[story_commented]'
      click_on 'Update options'
      expect(page).to have_content 'Settings changed'
      expect(page).to have_css('input[name="settings[story_commented]"]:not(:checked)')
      check 'settings[story_commented]'
      click_on 'Update options'
      expect(page).to have_content 'Settings changed'
      expect(page).to have_css('input[name="settings[story_commented]"]:checked')
    end
  end
end
