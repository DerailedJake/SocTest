require 'rails_helper'

RSpec.shared_examples 'show post' do
  it 'shows post' do
    if show_buttons
      expect(page).to have_content('Edit post')
      expect(page).to have_content('Delete post')
    else
      expect(page).not_to have_content('Edit post')
      expect(page).not_to have_content('Delete post')
    end
    expect(page).to have_content(target_post.user.full_name)
    expect(page).to have_content(target_post.body)
    if has_stories
      expect(page).to have_content(target_post.stories.first.title)
    else
      expect(page).to have_content('No connected stories!')
    end
  end
end

RSpec.describe 'Posts', type: :system do
  before do
    @second_user = user_with_posts_and_stories
    @current_user = user_with_posts_and_stories
  end

  describe 'GET /post' do
    before do
      @post = @current_user.posts.last
      @second_post = @second_user.posts.last
      @post_with_stories = @current_user.posts.create(attributes_for(:post, story_ids: @current_user.story_ids))
      @another_post_with_stories = @second_user.posts.create(attributes_for(:post, story_ids: @current_user.story_ids))
    end

    context 'when logged in' do
      before do
        login_as(@current_user)
      end

      context 'on owned post' do
        context 'without stories' do
          before do
            visit post_path(@post)
          end
          include_examples 'show post' do
            let(:target_post) { @post }
            let(:show_buttons) { true }
            let(:has_stories) { false }
          end
        end
        context 'with stories' do
          before do
            visit post_path(@post_with_stories)
          end
          include_examples 'show post' do
            let(:target_post) { @post_with_stories }
            let(:show_buttons) { true }
            let(:has_stories) { true }
          end
        end
      end

      context 'on someone elses post' do
        context 'with stories' do
          before do
            visit post_path(@second_post)
          end
          include_examples 'show post' do
            let(:target_post) { @second_post }
            let(:show_buttons) { false }
            let(:has_stories) { false }
          end
        end
        context 'without stories' do
          before do
            visit post_path(@another_post_with_stories)
          end
          include_examples 'show post' do
            let(:target_post) { @another_post_with_stories }
            let(:show_buttons) { false }
            let(:has_stories) { true }
          end
        end
      end
    end

    context 'when logged out' do
      before do
        visit post_path(@post)
      end
      it 'shows post without buttons' do
        expect(page).not_to have_content('Edit post')
        expect(page).not_to have_content('Delete post')
        expect(page).to have_content(@post.user.full_name)
        expect(page).to have_content(@post.body)
      end
    end
  end

  describe 'GET /posts/new' do
    context 'when logged in' do
      it 'shows form' do
        login_as(@current_user)
        visit new_post_path
        expect(page).to have_content 'New Post'
      end
    end

    context 'when logged out' do
      it 'should redirect to log in' do
        visit new_post_path
        expect(page).to have_content 'Log in'
      end
    end
  end

  describe 'POST #create' do
    before do
      login_as(@current_user)
      visit new_post_path
      @valid_post_data = attributes_for(:post)
    end

    context 'with valid data' do
      before do
        @first_story = @current_user.stories.first
        @second_story = @current_user.stories.second
        fill_in 'post[body]', with: @valid_post_data[:body]
        @image_css = "#post-#{Post.last.id + 1} img"
      end

      it 'creates post picture and stories' do
        attach_file 'post[picture]', "#{Rails.root}/app/assets/images/post_pictures/25_Pavilion_92_pic.jpeg"
        check 'post[story_ids][]', id: "post_story_ids_#{@first_story.id}"
        check 'post[story_ids][]', id: "post_story_ids_#{@second_story.id}"
        click_on 'Create'
        expect(page).to have_content(@valid_post_data[:body])
        expect(page).to have_content(@first_story.title)
        expect(page).to have_content(@second_story.title)
        expect(page).to have_css(@image_css)
      end

      it 'creates post without picture and stories' do
        click_on 'Create'
        expect(page).to have_content(@valid_post_data[:body])
        expect(page).to have_content('No connected stories!')
        expect(page).not_to have_css(@image_css)
      end
    end

    context 'with invalid data' do
      it 'creates post without picture' do
        fill_in 'post[body]', with: ''
        click_on 'Create'
        expect(page).to have_content("Body can't be blank")
      end
    end
  end

  describe 'GET /posts/edit' do
    context 'when logged in' do
      before do
        login_as(@current_user)
      end
      context 'on owned post' do
        it 'shows form' do
          @post = @current_user.posts.last
          visit edit_post_path(@post)
          expect(page).to have_content 'Edit Post'
        end
      end
      context 'on someone elses post' do
        it 'does not show it' do
          @post = @second_user.posts.last
          visit edit_post_path(@post)
          expect(page).not_to have_content 'Edit Post'
        end
      end
    end

    context 'when logged out' do
      it 'should redirect to log in' do
        visit edit_post_path(@current_user.posts.last)
        expect(page).to have_content 'Log in'
      end
    end
  end
end
