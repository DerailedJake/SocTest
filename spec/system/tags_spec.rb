require 'rails_helper'

RSpec.describe 'Tags', type: :system do
  before do
    @current_user = user_with_posts_and_stories
    create_list(:tag, 3)
  end
  context 'Header' do
    context 'when logged in' do
      it 'should properly display tags' do
        login_as(@current_user)
        visit tags_path
        expect(page).to have_content 'LifeBook Tags'
        Tag.all.each { |tag| expect(page).to have_content tag.name }
      end
    end

    context 'when logged out' do
      it 'should properly display tags' do
        visit tags_path
        expect(page).to have_content 'LifeBook Tags'
        Tag.all.each { |tag| expect(page).to have_content tag.name }
      end
    end
  end
end