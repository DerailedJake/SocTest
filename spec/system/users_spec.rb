require 'rails_helper'

RSpec.shared_examples 'check user pages' do
  it 'successfully renders user page' do
    expect(page).to have_content(target_user.full_name)
    expect(page).to have_content(target_user.stories.last.title)
    expect(page).to have_content(target_user.posts.last.body)
  end
  it 'has working pagination of stories' do
    within('#story-pagination') do
      click_link('3')
    end
    expect(page).to have_content(target_user.stories.first.title)
    expect(page).to have_content("#{target_user.full_name} stories:")
  end
  it 'has working pagination of posts' do
    within('#post-pagination' ) do
      click_link('3')
    end
    expect(page).to have_content(target_user.posts.first.body)
    expect(page).to have_content("#{target_user.full_name} posts:")
  end
end

RSpec.shared_examples 'check no posts or stories' do
  it 'shows empty page' do
    expect(page).to have_content 'has no posts'
    expect(page).to have_content 'has no stories'
  end
end

RSpec.shared_examples 'check index page' do
  before do
    4.times { User.create!(attributes_for(:user)) }
    visit users_index_path
  end
  it 'opens users list' do
    expect(page).to have_content(User.first.full_name)
    expect(page).to have_content(User.first.description)
  end

  it 'has working pagination of users' do
    within('#user-pagination') do
      click_link('2')
    end
    expect(page).to have_content(User.last.full_name)
    expect(page).to have_content(User.last.description)
  end

  it 'opens profile when clicked' do
    within('#user-pagination') do
      click_link('2')
    end
    click_link('Open profile')
    expect(page).to have_content('has no stories')
    expect(page).to have_content(User.last.full_name)
  end
end

RSpec.describe "Users", type: :system do
  before do
    @current_user = user_with_posts_and_stories
  end

  describe 'GET /' do
    context 'when logged in' do
      before do
        login_as(@current_user)
        visit users_home_path
      end

      include_examples 'check user pages' do
        let(:target_user) { @current_user }
      end
    end

    context 'without stories or posts' do
      before do
        login_as(@current_user)
        @current_user.stories.destroy_all
        @current_user.posts.destroy_all
        visit users_home_path
      end
      include_examples 'check no posts or stories'
    end

    context 'when logged out' do
      it 'redirects to log in' do
        visit users_home_path
        expect(page).to have_content 'Log in'
      end
    end
  end

  describe 'GET /users/profile' do
    before do
      @user = user_with_posts_and_stories
      login_as(@current_user)
      visit profile_path(@user)
    end

    context 'when logged in' do
      include_examples 'check user pages' do
        let(:target_user) { @user }
      end
    end

    context 'without stories or posts' do
      before do
        login_as(@current_user)
        @user.stories.destroy_all
        @user.posts.destroy_all
        visit profile_path(@user)
      end
      include_examples 'check no posts or stories'
    end

    context 'when logged out' do
      before do
        visit profile_path(@user)
      end
      include_examples 'check user pages' do
        let(:target_user) { @user }
      end
    end
  end

  describe 'GET /users/index' do
    context 'when logged in' do
      before do
        login_as @current_user
      end
      include_examples 'check index page'
    end

    context 'when logged out' do
      include_examples 'check index page'
    end
  end
end