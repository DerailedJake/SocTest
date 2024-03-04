require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  before(:example) do
    @current_user = user_with_posts_and_stories
    2.times { create :user }
  end

  context 'when loggen in' do
    before do
      login_as(@current_user)
    end
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

  context 'when loggen in' do
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
end