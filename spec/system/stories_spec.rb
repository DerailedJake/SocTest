require 'rails_helper'

RSpec.shared_examples 'show story' do
  # target_story show_buttons has_posts
  before do
    visit story_path(target_story)
  end
  it 'properly displays story' do
    buttons = ['Edit story', 'Add post to story', 'Delete story']
    buttons.each do |button|
      if show_buttons
        expect(page).to have_content(button)
      else
        expect(page).not_to have_content(button)
      end
    end
    expect(page).to have_content(target_story.user.full_name)
    expect(page).to have_content(target_story.title)
    expect(page).to have_content(target_story.description)
    if has_posts
      target_story.posts.each do |post|
        expect(page).to have_content(post.body)
        # scroll is slow, needs some time
        sleep(0.2)
        page.scroll_to(0, 10000)
        sleep(0.4)
      end
      expect(page).to have_content("You've reached the end of the story!")
    else
      expect(page).to have_content('No posts yet, stay tuned!')
    end
  end
end

RSpec.shared_examples 'update story' do
  # target_story has_posts posts[]
  it 'shows updated post' do
    click_on 'Update'
    expect(page).to have_content 'Story updated!'
    if has_posts
      posts.each do |post|
        expect(page).to have_content(post.body)
        # scroll is slow, needs some time
        sleep(0.1)
        page.scroll_to(0, 10000)
        sleep(0.4)
      end
      expect(page).to have_content("You've reached the end of the story!")
    else
      expect(page).to have_content('No posts yet, stay tuned!')
      posts.each do |post|
        expect(page).not_to have_content(post.body)
      end
    end
  end
end

RSpec.shared_examples 'should have all story buttons' do
  # story
  let(:story_selector) { '.container.my-5' }
  context 'edit button' do
    it 'has functional edit button' do
      within story_selector do
        click_on 'Edit story'
      end
      expect(page).to have_current_path(edit_story_path(story))
    end
  end
  context 'add post button' do
    it 'has functional add post button' do
      within story_selector do
        click_on 'Add post to story'
      end
      expect(page).to have_content 'New Post'
      fill_in 'post[body]', with: attributes_for(:post)[:body]
      click_on 'Create'
      expect(page).to have_content 'Connected stories:'
      expect(page).to have_content story.title
    end
  end
end

RSpec.describe 'Stories', type: :system do
  before do
    @second_user = user_with_posts_and_stories
    @current_user = user_with_posts_and_stories
  end

  describe 'GET /story' do
    before do
      @story = @current_user.stories.last
      @second_story = @second_user.stories.last
    end

    context 'when logged in' do
      before do
        login_as(@current_user)
      end

      context 'on owned story' do
        context 'without posts' do
          include_examples 'show story' do
            let(:target_story) { @story }
            let(:show_buttons) { true }
            let(:has_posts) { false }
          end
        end
        context 'with posts' do
          before do
            @story.update!(post_ids: @story.user.post_ids)
          end
          include_examples 'show story' do
            let(:target_story) { @story }
            let(:show_buttons) { true }
            let(:has_posts) { true }
          end
        end
      end

      context 'on someone elses story' do
        context 'without posts' do
          include_examples 'show story' do
            let(:target_story) { @second_story }
            let(:show_buttons) { false }
            let(:has_posts) { false }
          end
        end
        context 'with posts' do
          before do
            @second_story.update!(post_ids: @second_story.user.post_ids)
          end
          include_examples 'show story' do
            let(:target_story) { @second_story }
            let(:show_buttons) { false }
            let(:has_posts) { true }
          end
        end
      end
    end

    context 'when logged out' do
      context 'without stories' do
        include_examples 'show story' do
          let(:target_story) { @second_story }
          let(:show_buttons) { false }
          let(:has_posts) { false }
        end
      end
      context 'with stories' do
        before do
          @second_story.update!(post_ids: @second_story.user.post_ids)
        end
        include_examples 'show story' do
          let(:target_story) { @second_story }
          let(:show_buttons) { false }
          let(:has_posts) { true }
        end
      end
    end
  end

  describe 'GET /stories/new' do
    context 'when logged in' do
      it 'shows form' do
        login_as(@current_user)
        visit new_story_path
        expect(page).to have_selector(:link_or_button, 'Create')
        expect(page).to have_content 'New Story'
        expect(page).to have_content 'Story title'
        expect(page).to have_content 'Story description'
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
      visit new_story_path
      @valid_story_data = attributes_for(:story)
    end

    context 'with valid data' do
      it 'creates story' do
        fill_in 'story[title]', with: @valid_story_data[:title]
        fill_in 'story[description]', with: @valid_story_data[:description]
        click_on 'Create'
        expect(page).to have_content('Story created!')
        expect(page).to have_content(@valid_story_data[:title])
        expect(page).to have_content(@valid_story_data[:description])
      end
      it 'creates post without description' do
        fill_in 'story[title]', with: @valid_story_data[:title]
        click_on 'Create'
        expect(page).to have_content('Story created!')
        expect(page).to have_content(@valid_story_data[:title])
      end
    end

    context 'with invalid data' do
      it 'creates post without title' do
        fill_in 'story[description]', with: @valid_story_data[:description]
        click_on 'Create'
        expect(page).to have_content("Title can't be blank")
      end
    end
  end

  describe 'GET /stories/edit' do
    context 'when logged in' do
      before do
        login_as(@current_user)
      end
      context 'on owned story' do
        it 'shows form' do
          visit edit_story_path(@current_user.stories.last)
          expect(page).to have_content 'Edit Story'
        end
      end
      context 'on someone elses story' do
        it 'does not show form' do
          visit edit_story_path(@second_user.stories.last)
          expect(page).not_to have_content 'Edit Story'
        end
      end
    end

    context 'when logged out' do
      it 'redirects to log in' do
        visit edit_story_path(@current_user.stories.last)
        expect(page).to have_content 'Log in'
      end
    end
  end

  describe 'PUT #update' do
    before do
      login_as(@current_user)
      @valid_story_data = attributes_for(:story)
      @story = @current_user.stories.last
      @posts = @current_user.posts[0..2]
    end
    context 'with valid params' do
      before do
        visit edit_story_path(@story)
      end
      it 'updates title' do
        fill_in 'story[title]', with: @valid_story_data[:title]
        click_on 'Update'
        expect(page).to have_content 'Story updated!'
        expect(page).to have_current_path story_path(@story)
        expect(page).to have_content @valid_story_data[:title]
      end
      it 'updates description' do
        fill_in 'story[description]', with: @valid_story_data[:description]
        click_on 'Update'
        expect(page).to have_content 'Story updated!'
        expect(page).to have_current_path story_path(@story)
        expect(page).to have_content @valid_story_data[:description]
      end
    end

    context 'when story has posts' do
      before do
        @story.update!(post_ids: [@posts[0].id, @posts[1].id])
        visit edit_story_path(@story)
      end
      context 'connects new posts' do
        before do
          check 'story[post_ids][]', id: "story_post_ids_#{@posts[2].id}"
        end
        include_examples 'update story' do
          let(:target_story) { @story }
          let(:has_posts) { true }
          let(:posts) { @posts }
        end

      end
      context 'removes connected posts' do
        before do
          uncheck 'story[post_ids][]', id: "story_post_ids_#{@posts[0].id}"
          uncheck 'story[post_ids][]', id: "story_post_ids_#{@posts[1].id}"
        end
        include_examples 'update story' do
          let(:target_story) { @story }
          let(:has_posts) { false }
          let(:posts) { @posts }
        end
      end
    end

    context 'when story has no posts' do
      before do
        @story.update!(post_ids: [])
        visit edit_story_path(@story)
        @posts.each do |story|
          check 'story[post_ids][]', id: "story_post_ids_#{story.id}"
        end
      end
      include_examples 'update story' do
        let(:target_story) { @story }
        let(:has_posts) { true }
        let(:posts) { @posts }
      end
    end
  end

  describe 'BUTTONS' do
    before do
      @story = @current_user.stories.last
      @second_story = @second_user.stories.last
    end

    context 'when logged in' do
      before do
        login_as(@current_user)
      end

      context 'on owned story' do
        before do
          visit story_path(@story)
        end
        include_examples 'should have all story buttons' do
          let(:story) { @story }
        end
      end

      context 'on someone elses story' do
        it 'has no buttons' do
          visit story_path(@second_story)
          buttons = page.find_all('.container.my-5 .btn')
          expect(buttons.count).to eql(0)
        end
      end
    end

    context 'when logged out' do
      it 'has no buttons' do
        visit story_path(@second_story)
        buttons = page.find_all('.container.my-5 .btn')
        expect(buttons.count).to eql(0)
      end
    end
  end
end
