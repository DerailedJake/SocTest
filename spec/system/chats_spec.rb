require 'rails_helper'

RSpec.describe 'Chat', type: :system do
  before do
    @current_user = user_with_posts_and_stories
    @users = create_list(:user, 3)
    @second_user = @users.first
    @selector_chat_window = '#turbo-chat-container'
    @selector_min_chat = '#minimize-chat'
    login_as @current_user
  end

  describe 'chats display' do
    context 'with multiple chats' do
      before do
        @users = create_list(:user, 9)
        @users.each do |user|
          create(:chat, user_ids: [@current_user.id, user.id])
        end
        visit root_path
      end
      it 'correctly handles chats' do
        expect(page).to have_content 'Chats'
        click_on 'Chats'
        @users.each do |user|
          chat_functions_properly(user)
        end
      end
    end
  end

  describe 'opening new chats' do
    context 'without chats' do
      it 'opens chat window' do
        visit profile_path @second_user
        page.find("#direct-message-#{@second_user.id}").click
        expect(page).to have_content @second_user.full_name
        find('a', text: "Chat with #{@second_user.full_name}").click
        chat_functions_properly @second_user
      end
    end
    context 'with chats' do
      before do
        @users = create_list(:user, 9)
        @users.each do |user|
          create(:chat, user_ids: [@current_user.id, user.id])
        end
        @another_user = create(:user)
      end
      it 'opens chat window' do
        visit profile_path(@another_user)
        page.find("#direct-message-#{@another_user.id}").click
        expect(page).to have_content @another_user.full_name
        find('a', text: "Chat with #{@another_user.full_name}").click
        chat_functions_properly @another_user
      end
    end
  end

  describe 'messages' do
    before do
      @another_user = create(:user)
      @chat = create(:chat, user_ids: [@current_user.id, @another_user.id])
    end
    context 'sending' do
      it 'is successful' do
        visit root_path
        click_on 'Chats'
        find('a', text: "Chat with #{@another_user.full_name}").click
        fill_in 'content', with: 'New message'
        click_on 'Send'
        expect(page).to have_content 'New message'
        expect(page).to have_selector('div', text: 'New message')
      end
    end
    context 'display' do
      before do
        12.times do |i|
          @chat.messages.create(user_id: @current_user.id, content: "Message nr-#{i}")
        end
      end
      it 'shows and scroll messages' do
        visit root_path
        click_on 'Chats'
        find('a', text: "Chat with #{@another_user.full_name}").click
        expect(page).to have_content 'Message nr-4'
        expect(page).to have_content 'Message nr-11'
        expect(page).not_to have_content 'Message nr-0'
        page.find('#chat-messages-container').scroll_to(:top)
        sleep(0.3)
        expect(page).to have_content 'Message nr-0'
        fill_in 'content', with: 'New message'
        click_on 'Send'
        expect(page).to have_content 'New message'
        expect(page).to have_selector('div', text: 'New message')
      end
    end
  end

  def chat_is_present(user)
    within @selector_chat_window do
      expect(page).to have_content user.full_name
      expect(page).to have_content 'Send your first message'
    end
  end

  def chat_functions_properly(user)
    chat_name = "Chat with #{user.full_name}"
    chat_is_present user
    within @selector_chat_window do
      find('a', text: chat_name).click
      within '#turbo-chat-header' do
        expect(page).to have_content chat_name
        page.find('a', text: chat_name).click
        expect(page).to have_content 'Chats'
      end
    end
    chat_is_present user
  end
end
