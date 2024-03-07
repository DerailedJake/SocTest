require 'rails_helper'

#
# Sleep(0.2) to prevent database connection issues due to tests going far too quickly
#

RSpec.shared_examples 'check static pages' do
  describe 'GET /landing' do
    it 'returns a success response' do
      visit static_pages_landing_path
      expect(page).to have_content 'Join Today'
      expect(page).to have_content User.first.full_name
    end
  end

  describe 'GET /about' do
    it 'returns a success response' do
      visit static_pages_about_path
      expect(page).to have_content 'Information on github readme.'
    end
  end

  describe 'GET /contact' do
    it 'returns a success response' do
      visit static_pages_contact_path
      expect(page).to have_content 'Hey, thanks for stopping by.'
    end
  end

  describe 'GET /legal' do
    it 'returns a success response' do
      visit static_pages_legal_path
      expect(page).to have_content 'Legal Mumbo Jumbo'
    end
  end
end

RSpec.shared_examples 'check header links' do
  context 'LifeBook' do
    it 'returns a success response' do
      within('.navbar') { click_on 'LifeBook' }
      sleep(0.2)
      if logged_in
        expect(page).to have_current_path(root_path)
      else
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end
  context 'Users' do
    it 'returns a success response' do
      within('.navbar') { click_on 'Users' }
      sleep(0.2)
      expect(page).to have_content('LifeBook Users')
    end
  end
  context 'Stories' do
    it 'returns a success response' do
      within('.navbar') { click_on 'Stories' }
      sleep(0.2)
      expect(page).to have_content('Discover New Stories!')
    end
  end
  context 'Landing' do
    it 'returns a success response' do
      within('.navbar') { click_on 'Landing' }
      sleep(0.2)
      expect(page).to have_content('Join Today')
    end
  end
  context 'New story' do
    it 'returns a success response' do
      if logged_in
        within('.navbar') { click_on 'New story' }
        sleep(0.2)
        expect(page).to have_content('New Story')
      else
        expect(page).not_to have_content('New story')
      end
    end
  end
  context 'New post' do
    it 'returns a success response' do
      if logged_in
        within('.navbar') { click_on 'New post' }
        sleep(0.2)
        expect(page).to have_content('New Post')
      else
        expect(page).not_to have_content('New post')
      end
    end
  end
end

RSpec.describe 'StaticPages', type: :system do
  before do
    @current_user = user_with_posts_and_stories
    @second_user = user_with_posts_and_stories
    @third_user = user_with_posts_and_stories
  end
  context 'pages' do
    context 'when logged in' do
      before do
        login_as(@current_user)
        sleep(0.1)
      end
      include_examples 'check static pages'
    end

    context 'when logged out' do
      before do
        sleep(0.1)
      end
      include_examples 'check static pages'
    end
  end

  context 'Header' do
    context 'when logged in' do
      before do
        login_as(@current_user)
        visit static_pages_about_path
      end
      include_examples 'check header links' do
        let(:logged_in) { true }
      end
    end

    context 'when logged out' do
      before do
        visit static_pages_about_path
      end
      include_examples 'check header links' do
        let(:logged_in) { false }
      end
    end
  end
end