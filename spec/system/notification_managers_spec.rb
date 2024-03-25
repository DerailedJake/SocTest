require 'rails_helper'

RSpec.shared_examples 'shows notification' do |message, amount = 1|
  it 'shows notifications' do
    visit notifications_path
    expect(page).to have_content message
    expect(Notification.all.count).to eq(amount)
  end
end

RSpec.shared_examples 'does not show notifications' do
  it 'shows notifications' do
    visit notifications_path
    expect(page).to have_content 'You have no notifications'
    expect(Notification.all.count).to eq(0)
  end
end

RSpec.describe 'NotificationManagers', type: :system do
  before do
    @current_user = user_with_posts_and_stories
    @another_user = User.create!(attributes_for(:user))
    @current_user.contacts.create!(acquaintance: @another_user)
    login_as @current_user
  end

  describe 'change options' do
    it 'renders settings page' do
      visit notification_options_path
      expect(page).to have_content 'Notification Options:'
    end
    it 'properly updates settings' do
      visit notification_options_path
      uncheck 'settings[post_commented]'
      click_on 'Update options'
      expect(page).to have_content 'Settings changed'
      expect(page).to have_css('input[name="settings[post_commented]"]:not(:checked)')
      check 'settings[post_commented]'
      click_on 'Update options'
      expect(page).to have_content 'Settings changed'
      expect(page).to have_css('input[name="settings[post_commented]"]:checked')
    end
  end

  describe 'receiving notifications' do
    context 'without any' do
      include_examples 'does not show notifications'
    end
    context 'when observed user creates a story' do
      before { @another_user.stories.create!(attributes_for(:story)) }
      include_examples 'shows notification', 'User you observe made a new story'
    end
    context 'when observed user creates a post' do
      before { @another_user.posts.create!(attributes_for(:post)) }
      include_examples 'shows notification', 'User you observe made a new post'
    end
  end

  describe 'getting notified when user post is commented' do
    context 'another users comment' do
      before do
        post = @current_user.posts.create!(attributes_for(:post))
        @another_user.comments.create!(attributes_for(:comment).merge(post:))
      end
      include_examples 'shows notification', 'Your post has a new comment'
    end
    context 'user owned comment' do
      before do
        post = @current_user.posts.create!(attributes_for(:post))
        @current_user.comments.create!(attributes_for(:comment).merge(post:))
      end
      include_examples 'does not show notifications'
    end
  end


  describe 'getting notified when user gets a like' do
    context 'from himself' do
      before do
        story = @current_user.stories.create!(attributes_for(:story))
        post = @current_user.posts.create!(attributes_for(:post))
        comment = @current_user.comments.create!(attributes_for(:comment).merge(post:))
        [story, post, comment].each do |likeable|
          @current_user.likes.create!(likeable:)
        end
      end
      include_examples 'does not show notifications'
    end
    context 'from another user' do
      context 'on story' do
        before do
          story = @current_user.stories.create!(attributes_for(:story))
          @another_user.likes.create!(likeable: story)
        end
        include_examples 'shows notification', 'Your story has a new like'
      end
      context 'on post' do
        before do
          post = @current_user.posts.create!(attributes_for(:post))
          @another_user.likes.create!(likeable: post)
        end
        include_examples 'shows notification', 'Your post has a new like'
      end
      context 'on comment' do
        before do
          post = @current_user.posts.create!(attributes_for(:post))
          comment = @current_user.comments.create!(attributes_for(:comment).merge(post:))
          @another_user.likes.create!(likeable: comment)
        end
        include_examples 'shows notification', 'Your comment has a new like'
      end
    end
  end
end
