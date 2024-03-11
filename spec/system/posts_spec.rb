require 'rails_helper'

RSpec.shared_examples 'show post' do
  # target_post show_buttons has_stories
  before do
    visit post_path(target_post)
  end
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
      expect(page).to have_content('Connected stories:')
      within('#story-pagination') do
        click_link('3')
      end
      expect(page).to have_content(target_post.stories.last.title)
      expect(page).to have_content('Connected stories:')
    else
      expect(page).to have_content('No connected stories!')
    end
  end
end

RSpec.shared_examples 'update post' do
  # target_post has_stories stories[]
  it 'shows updated post' do
    click_on 'Update'
    expect(page).to have_content('Post updated!')
    expect(page).to have_current_path(post_path(target_post))
    if has_stories
      expect(page).to have_content('Connected stories:')
      stories.each do |story|
        expect(page).to have_content(story.title)
      end
    else
      expect(page).to have_content('No connected stories!')
      stories.each do |story|
        expect(page).not_to have_content(story.title)
      end
    end
  end
end

RSpec.shared_examples 'should have just view buttons' do
  # post
  let(:post_selector) { "#post-#{post.id}" }
  before do
    page.find(post_selector).hover
  end
  it 'has functional view button' do
    within post_selector do
      click_on 'View post'
    end
    expect(page).to have_current_path(post_path(post))
  end
  it 'has no other buttons' do
    buttons = page.find_all("#{post_selector} .post-buttons-container .btn")
    expect(buttons.count).to eql(1)
    expect(buttons[0].text).to have_content('View post')
  end
end

RSpec.shared_examples 'should have all buttons' do
  # post
  let(:post_selector) { "#post-#{post.id}" }
  before do
    page.find(post_selector).hover
  end
  it 'has functional view button' do
    within post_selector do
      click_on 'View post'
    end
    expect(page).to have_current_path(post_path(post))
  end
  it 'has functional edit button' do
    within post_selector do
      click_on 'Edit'
    end
    expect(page).to have_current_path(edit_post_path(post))
  end
  it 'has functional delete button' do
    within post_selector do
      click_on 'Delete'
    end
    expect(page).to have_current_path(root_path)
    expect(page).to have_content 'Post removed'
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
      @post_with_stories = @current_user.posts.create!(attributes_for(:post, story_ids: @current_user.story_ids))
      @another_post_with_stories = @second_user.posts.create!(attributes_for(:post, story_ids: @second_user.story_ids))
    end

    context 'when logged in' do
      before do
        login_as(@current_user)
      end

      context 'on owned post' do
        context 'without stories' do
          include_examples 'show post' do
            let(:target_post) { @post }
            let(:show_buttons) { true }
            let(:has_stories) { false }
          end
        end
        context 'with stories' do
          include_examples 'show post' do
            let(:target_post) { @post_with_stories }
            let(:show_buttons) { true }
            let(:has_stories) { true }
          end
        end
      end

      context 'on someone elses post' do
        context 'without stories' do
          include_examples 'show post' do
            let(:target_post) { @second_post }
            let(:show_buttons) { false }
            let(:has_stories) { false }
          end
        end
        context 'with stories' do
          include_examples 'show post' do
            let(:target_post) { @another_post_with_stories }
            let(:show_buttons) { false }
            let(:has_stories) { true }
          end
        end
      end
    end

    context 'when logged out' do
      context 'without stories' do
        include_examples 'show post' do
          let(:target_post) { @post }
          let(:show_buttons) { false }
          let(:has_stories) { false }
        end
      end
      context 'with stories' do
        include_examples 'show post' do
          let(:target_post) { @post_with_stories }
          let(:show_buttons) { false }
          let(:has_stories) { true }
        end
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
        attach_file 'post[picture]', "#{Rails.root}/app/assets/images/test_avt.jpeg"
        check 'post[story_ids][]', id: "post_story_ids_#{@first_story.id}"
        check 'post[story_ids][]', id: "post_story_ids_#{@second_story.id}"
        click_on 'Create'
        expect(page).to have_content('Post created!')
        expect(page).to have_content(@valid_post_data[:body])
        expect(page).to have_content(@first_story.title)
        expect(page).to have_content(@second_story.title)
        expect(page).to have_css(@image_css)
      end

      it 'creates post without picture and stories' do
        click_on 'Create'
        expect(page).to have_content('Post created!')
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

  describe 'PUT #update' do
    before do
      login_as(@current_user)
      @valid_post_body = 'New valid post body'
      @post = @current_user.posts.last
      @valid_post_picture = "#{Rails.root}/app/assets/images/test_avt.jpeg"
      @stories = @current_user.stories[0..2]
    end
    context 'with valid params' do
      before do
        visit edit_post_path(@post)
      end
      it 'updates picture' do
        attach_file 'post[picture]', @valid_post_picture
        click_on 'Update'
        expect(page).to have_content('Post updated!')
        expect(page).to have_current_path(post_path(@post))
        updated_image_src = @valid_post_picture.split('/').last
        image_src = page.find("#post-#{@post.id} img")['src'].split('/').last
        expect(image_src).to eql(updated_image_src)
      end
      it 'removes picture' do
        attach_file 'post[picture]', @valid_post_picture
        click_on 'Update'
        expect(page).to have_content('Post updated!')
        expect(page).to have_current_path(post_path(@post))
        expect(page).not_to have_selector("#post-#{@post.id} img")
      end
      it 'updates body' do
        fill_in 'post[body]', with: @valid_post_body
        click_on 'Update'
        expect(page).to have_content('Post updated!')
        expect(page).to have_current_path(post_path(@post))
        expect(page).to have_content(@valid_post_body)
      end
    end

    context 'when post has stories' do
      before do
        @post.update!(story_ids: [@stories[0].id, @stories[1].id])
        visit edit_post_path(@post)
      end
      context 'connects new stories' do
        before do
          check 'post[story_ids][]', id: "post_story_ids_#{@stories[2].id}"
        end
        include_examples 'update post' do
          let(:target_post) { @post }
          let(:has_stories) { true }
          let(:stories) { @stories }
        end

      end
      context 'removes connected stories' do
        before do
          uncheck 'post[story_ids][]', id: "post_story_ids_#{@stories[0].id}"
          uncheck 'post[story_ids][]', id: "post_story_ids_#{@stories[1].id}"
        end
        include_examples 'update post' do
          let(:target_post) { @post }
          let(:has_stories) { false }
          let(:stories) { @stories }
        end
      end
    end

    context 'when post has no stories' do
      before do
        @post.update!(story_ids: [])
        visit edit_post_path(@post)
        @stories.each do |story|
          check 'post[story_ids][]', id: "post_story_ids_#{story.id}"
        end
      end
      include_examples 'update post' do
        let(:target_post) { @post }
        let(:has_stories) { true }
        let(:stories) { @stories }
      end
    end
  end

  describe 'BUTTONS' do
    context 'inside profile page' do
      context 'when logged in' do
        before do
          login_as(@current_user)
          @post = @current_user.posts.last
          @second_post = @second_user.posts.last
        end

        context 'on owned post' do
          before do
            visit profile_path(@current_user)
          end
          include_examples 'should have all buttons' do
            let(:post) { @post }
          end
        end

        context 'on someone elses post' do
          before do
            visit profile_path(@second_user)
          end
          include_examples 'should have just view buttons' do
            let(:post) { @second_post }
          end
        end
      end

      context 'when logged out' do
        before do
          @second_post = @second_user.posts.last
          visit profile_path(@second_user)
        end
        include_examples 'should have just view buttons' do
          let(:post) { @second_post }
        end
      end
    end

    context 'inside story view page' do
      before do
        @story = @current_user.stories.first
        @story.update!(post_ids: @current_user.post_ids )
        @second_story = @second_user.stories.first
        @second_story.update!(post_ids: @second_user.post_ids )
      end

      context 'when logged in' do
        before do
          login_as(@current_user)
        end

        context 'on owned story' do
          before do
            visit story_path(@story)
          end
          include_examples 'should have all buttons' do
            let(:post) { @story.posts.first }
          end
        end

        context 'on someone elses story' do
          before do
            visit story_path(@second_story)
          end
          include_examples 'should have just view buttons' do
            let(:post) { @second_story.posts.first }
          end
        end
      end

      context 'when logged out' do
        before do
          visit story_path(@second_story)
        end
        include_examples 'should have just view buttons' do
          let(:post) { @second_story.posts.first }
        end
      end
    end
  end
end
