require 'rails_helper'
RSpec.shared_examples 'visit user page' do
  it 'successfully renders user page' do
    expect(page).to have_content(target_user.full_name)
    expect(page).to have_content(target_user.stories.last.title)
    expect(page).to have_content(target_user.posts.last.body)
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
        @story = @current_user.stories.last
        @post = @current_user.posts.last
        visit users_home_path
      end

      include_examples 'visit user page' do
        let(:target_user) { @current_user }
      end

      it 'has working pagination of stories' do
        within('#story-pagination') do
          click_link('3')
        end
        expect(page).to have_content(@current_user.stories.first.title)
      end

      it 'has working pagination of posts' do
        within('#post-pagination') do
          click_link('3')
        end
        expect(page).to have_content(@current_user.posts.first.body)
      end
    end

    context 'without stories or posts' do
      it 'returns a success response' do
        login_as(@current_user)
        @current_user.stories.destroy_all
        @current_user.posts.destroy_all
        visit users_home_path
        expect(page).to have_content 'has no posts'
        expect(page).to have_content 'has no stories'
      end
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
      @story = @user.stories.last
      @post = @user.posts.last
      visit profile_path(@user)
    end

    context 'when logged in' do
      include_examples 'visit user page' do
        let(:target_user) { @user }
      end

      it 'has working pagination of stories' do
        within('#story-pagination') do
          click_link('3')
        end
        expect(page).to have_content(@user.stories.first.title)
      end

      it 'has working pagination of posts' do
        within('#post-pagination') do
          click_link('3')
        end
        expect(page).to have_content(@user.posts.first.body)
      end
    end

    context 'without stories or posts' do
      it 'returns a success response' do
        login_as(@current_user)
        @user.stories.destroy_all
        @user.posts.destroy_all
        visit profile_path(@user)
        expect(page).to have_content 'has no posts'
        expect(page).to have_content 'has no stories'
      end
    end

    context 'when logged out' do
      before do
        visit profile_path(@user)
      end
      include_examples 'visit user page' do
        let(:target_user) { @user }
      end
    end
  end

  describe 'GET /users/index' do
    context 'when logged in' do
      before do
        login_as @current_user
        12.times { User.create!(attributes_for(:user)) }
        visit users_index_path
      end

      it 'opens users list' do
        expect(page).to have_content(User.first.full_name)
        expect(page).to have_content(User.first.description)
        expect(page).to have_content(User.third.full_name)
        expect(page).to have_content(User.third.description)
      end

      it 'has working pagination of users' do
        within('#user-pagination') do
          click_link('3')
        end
        expect(page).to have_content(User.last.full_name)
        expect(page).to have_content(User.last.description)
      end

      it 'opens profile when clicked' do
        within('#user-pagination') do
          click_link('3')
        end
        click_link('Open profile')
        expect(page).to have_content(User.last.full_name)
        expect(page).to have_content('has no stories')
      end
    end

    context 'when logged out' do
      before do
        12.times { User.create!(attributes_for(:user)) }
        visit users_index_path
      end

      it 'opens users list' do
        expect(page).to have_content(User.first.full_name)
        expect(page).to have_content(User.first.description)
      end

      it 'has working pagination of users' do
        within('#user-pagination') do
          click_link('3')
        end
        expect(page).to have_content(User.last.full_name)
        expect(page).to have_content(User.last.description)
      end

      it 'opens profile when clicked' do
        within('#user-pagination') do
          click_link('3')
        end
        click_link('Open profile')
        expect(page).to have_content(User.last.full_name)
        expect(page).to have_content('has no stories')
      end
    end
  end
end