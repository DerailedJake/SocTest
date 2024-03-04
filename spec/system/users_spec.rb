require 'rails_helper'

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
      end

      it 'returns a success response' do
        visit users_home_path
        expect(page).to have_content(@current_user.full_name)
        expect(page).to have_content(@story.title)
        expect(page).to have_content(@post.body)
      end

      it 'has working pagination of stories' do
        visit users_home_path
        within('#story-pagination') do
          click_link('3')
        end
        expect(page).to have_content(@current_user.stories.first.title)
      end

      it 'has working pagination of posts' do
        visit users_home_path
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
      it 'returns a success response' do
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
    end

    context 'when logged in' do
      it 'returns a success response' do
        visit profile_path(@user)
        expect(page).to have_content(@user.full_name)
        expect(page).to have_content(@story.title)
        expect(page).to have_content(@post.body)
      end

      it 'has working pagination of stories' do
        visit profile_path(@user)
        within('#story-pagination') do
          click_link('3')
        end
        expect(page).to have_content(@user.stories.first.title)
      end

      it 'has working pagination of posts' do
        visit profile_path(@user)
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
      it 'returns a success response' do
        visit profile_path(@user)
        expect(page).to have_content(@user.full_name)
        expect(page).to have_content(@story.title)
        expect(page).to have_content(@post.body)
      end
    end
  end

  describe 'GET /users/index' do
    context 'when logged in' do
      before do
        login_as @current_user
        12.times { User.create!(attributes_for(:user)) }
      end

      it 'opens users list' do
        visit users_index_path
        expect(page).to have_content(User.first.full_name)
        expect(page).to have_content(User.first.description)
        expect(page).to have_content(User.third.full_name)
        expect(page).to have_content(User.third.description)
      end

      it 'has working pagination of users' do
        visit users_index_path
        within('#user-pagination') do
          click_link('3')
        end
        expect(page).to have_content(User.last.full_name)
        expect(page).to have_content(User.last.description)
      end

      it 'opens profile when clicked' do
        visit users_index_path
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
      end

      it 'opens users list' do
        visit users_index_path
        expect(page).to have_content(User.first.full_name)
        expect(page).to have_content(User.first.description)
      end

      it 'has working pagination of users' do
        visit users_index_path
        within('#user-pagination') do
          click_link('3')
        end
        expect(page).to have_content(User.last.full_name)
        expect(page).to have_content(User.last.description)
      end

      it 'opens profile when clicked' do
        visit users_index_path
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