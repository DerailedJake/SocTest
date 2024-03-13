require 'rails_helper'

RSpec.shared_examples 'comments modal' do
  # path target_post has_comments
  it 'shows comments' do
    visit path
    within "#post-#{target_post.id}" do
      click_on 'Show comments!'
    end
    within "#commentsModal-#{target_post.id}" do
      expect(page).to have_content('Close')
      if has_comments
        expect(page).to have_content(target_post.comments.last.body)
        click_on('Show more comments')
        expect(page).to have_content(target_post.comments.first.body)
      else
        expect(page).to have_content('No comments here!')
      end
    end
  end
end

RSpec.shared_examples 'comments on post' do
  # path target_post has_comments
  it 'shows comments' do
    visit path
    scroll_page
    within "#post-comments-#{target_post.id}" do
      if has_comments
        expect(page).to have_content(target_post.comments.last.body)
        click_on('Show more comments')
        scroll_page
        expect(page).to have_content(target_post.comments.first.body)
      else
        expect(page).to have_content('No comments here!')
      end
    end
  end
end

RSpec.shared_examples 'create comment' do
  # path target_post scroll
  before do
    visit path
    if defined?(scroll)
      scroll_page
    else
      within "#post-#{target_post.id}" do
        click_on 'Show comments!'
      end
    end
  end
  context 'with valid params' do
    it 'creates comment' do
      within "#post-comments-#{target_post.id}" do
        fill_in 'comment[body]', with: 'New comment body'
        click_on 'Comment'
      end
      expect(page).to have_content('Comment created!')
      expect(target_post.comments.last.body).to eq('New comment body')
      expect(page).to have_content('New comment body')
    end
  end
  context 'with form empty' do
    it 'fails to create and alerts' do
      within "#post-comments-#{target_post.id}" do
        click_on 'Comment'
      end
      expect(page).to have_content("Body can't be blank")
    end
  end
end

RSpec.shared_examples 'update comment' do
  # path target_post target_comment inside_of_modal
  it 'updates comment' do
    visit path
    if inside_of_modal
      container_selector = "#commentsModal-#{target_post.id}"
      within "#post-#{target_post.id}" do
        click_on 'Show comments!'
      end
    else
      container_selector = "#post-#{target_post.id}"
      scroll_page
    end
    within container_selector do
      within "#comment-#{target_comment.id}" do
        expect(page).to have_content('Edit')
        expect(page).to have_content(target_comment.body)
        click_on 'Edit'
        fill_in 'comment[body]', with: 'New comment body'
        click_on 'Update'
      end
      expect(page).to have_content('New comment body')
      expect(target_comment.reload.body).to eq('New comment body')
    end
    expect(page).to have_content('Comment updated!')
  end
end

RSpec.describe 'Comments', type: :system do
  before do
    @second_user = user_with_commented_posts_and_story
    @current_user = user_with_commented_posts_and_story
  end

  describe 'SHOW on profile page' do
    before do
      @post = @current_user.posts.last
      @second_post = @second_user.posts.last
    end

    context 'when logged IN' do
      before do
        login_as(@current_user)
      end

      context 'on owned post' do
        context 'with comments' do
          include_examples 'comments modal' do
            let(:path) { root_path }
            let(:target_post) { @post }
            let(:has_comments) { true }
          end
        end
        context 'without comments' do
          before do
            @post.comments.destroy_all
          end
          include_examples 'comments modal' do
            let(:path) { root_path }
            let(:target_post) { @post }
            let(:has_comments) { false }
          end
        end
      end

      context 'on someone elses post' do
        context 'with comments' do
          include_examples 'comments modal' do
            let(:path) { profile_path(@second_user) }
            let(:target_post) { @second_post }
            let(:has_comments) { true }
          end
        end
        context 'without comments' do
          before do
            @second_post.comments.destroy_all
          end
          include_examples 'comments modal' do
            let(:path) { profile_path(@second_user) }
            let(:target_post) { @second_post }
            let(:has_comments) { false }
          end
        end
      end
    end

    context 'while logged OUT' do
      context 'with comments' do
        include_examples 'comments modal' do
          let(:path) { profile_path(@second_user) }
          let(:target_post) { @second_post }
          let(:has_comments) { true }
        end
      end
      context 'without comments' do
        before do
          @second_post.comments.destroy_all
        end
        include_examples 'comments modal' do
          let(:path) { profile_path(@second_user) }
          let(:target_post) { @second_post }
          let(:has_comments) { false }
        end
      end
    end
  end

  describe 'SHOW on story page' do
    before do
      @story = @current_user.stories.first
      @second_story = @second_user.stories.first
      @post = @story.posts.first
      @second_post = @second_story.posts.first
    end

    context 'when logged IN' do
      before do
        login_as(@current_user)
      end

      context 'on owned post' do
        context 'with comments' do
          include_examples 'comments modal' do
            let(:path) { story_path(@story) }
            let(:target_post) { @post }
            let(:has_comments) { true }
          end
        end
        context 'without comments' do
          before do
            @post.comments.destroy_all
          end
          include_examples 'comments modal' do
            let(:path) { story_path(@story) }
            let(:target_post) { @post }
            let(:has_comments) { false }
          end
        end
      end

      context 'on someone elses post' do
        context 'with comments' do
          include_examples 'comments modal' do
            let(:path) { story_path(@second_story) }
            let(:target_post) { @second_post }
            let(:has_comments) { true }
          end
        end
        context 'without comments' do
          before do
            @second_post.comments.destroy_all
          end
          include_examples 'comments modal' do
            let(:path) { story_path(@second_story) }
            let(:target_post) { @second_post }
            let(:has_comments) { false }
          end
        end
      end
    end

    context 'while logged OUT' do
      context 'with comments' do
        include_examples 'comments modal' do
          let(:path) { story_path(@second_story) }
          let(:target_post) { @second_post }
          let(:has_comments) { true }
        end
      end
      context 'without comments' do
        before do
          @second_post.comments.destroy_all
        end
        include_examples 'comments modal' do
          let(:path) { story_path(@second_story) }
          let(:target_post) { @second_post }
          let(:has_comments) { false }
        end
      end
    end
  end

  describe 'SHOW on post page' do
    before do
      @post = @current_user.posts.first
      @second_post = @second_user.posts.first
    end

    context 'when logged IN' do
      before do
        login_as(@current_user)
      end

      context 'on owned post' do
        context 'with comments' do
          include_examples 'comments on post' do
            let(:path) { post_path(@post) }
            let(:target_post) { @post }
            let(:has_comments) { true }
          end
        end
        context 'without comments' do
          before do
            @post.comments.destroy_all
          end
          include_examples 'comments on post' do
            let(:path) { post_path(@post) }
            let(:target_post) { @post }
            let(:has_comments) { false }
          end
        end
      end

      context 'on someone elses post' do
        context 'with comments' do
          include_examples 'comments on post' do
            let(:path) { post_path(@second_post) }
            let(:target_post) { @second_post }
            let(:has_comments) { true }
          end
        end
        context 'without comments' do
          before do
            @second_post.comments.destroy_all
          end
          include_examples 'comments on post' do
            let(:path) { post_path(@second_post) }
            let(:target_post) { @second_post }
            let(:has_comments) { false }
          end
        end
      end
    end

    context 'while logged OUT' do
      context 'with comments' do
        include_examples 'comments on post' do
          let(:path) { post_path(@second_post) }
          let(:target_post) { @second_post }
          let(:has_comments) { true }
        end
      end
      context 'without comments' do
        before do
          @second_post.comments.destroy_all
        end
        include_examples 'comments on post' do
          let(:path) { post_path(@second_post) }
          let(:target_post) { @second_post }
          let(:has_comments) { false }
        end
      end
    end
  end

  describe 'CREATE' do
    before do
      @post = @current_user.posts.last
      login_as(@current_user)
      @post.comments.update_all(user_id: @current_user.id)
    end
    context 'in modal' do
      include_examples 'create comment' do
        let(:path)        { profile_path(@current_user) }
        let(:target_post) { @post }
      end
    end
    context 'in post page' do
      include_examples 'create comment' do
        let(:path)        { post_path(@post) }
        let(:target_post) { @post }
        let(:scroll)      { true }
      end
    end
  end

  describe 'UPDATE' do
    before do
      @post = @current_user.posts.last
      login_as(@current_user)
      @post.comments.update_all(user_id: @current_user.id)
      @comment = @post.comments.last
    end
    context 'in modal' do
      include_examples 'update comment' do
        let(:path)            { profile_path(@current_user) }
        let(:target_post)     { @post }
        let(:target_comment)  { @comment }
        let(:inside_of_modal) { true }
      end
    end
    context 'in post page' do
      include_examples 'update comment' do
        let(:path)            { post_path(@post) }
        let(:target_post)     { @post }
        let(:target_comment)  { @comment }
        let(:inside_of_modal) { false }
      end
    end
  end

  describe 'DELETE' do
    before do
      @post = @current_user.posts.last
      login_as(@current_user)
      @post.comments.update_all(user_id: @current_user.id)
      @comment = @post.comments.last
    end
    context 'in modal' do
      it 'deletes comment' do
        visit profile_path(@current_user)
        within "#post-#{@post.id}" do
          click_on 'Show comments!'
        end
        within "#commentsModal-#{@post.id}" do
          within "#comment-#{@comment.id}" do
            expect(page).to have_content('Delete')
            expect(page).to have_content(@comment.body)
            click_on 'Delete'
          end
          accept_alert
          expect(page).not_to have_content(@comment.body)
        end
        expect(page).to have_content('Comment deleted!')
      end
    end
    context 'in post page' do
      it 'deletes comment' do
        visit post_path(@post)
        scroll_page
        within "#post-#{@post.id}" do
          within "#comment-#{@comment.id}" do
            expect(page).to have_content('Delete')
            expect(page).to have_content(@comment.body)
            click_on 'Delete'
          end
          accept_alert
          expect(page).not_to have_content(@comment.body)
        end
        expect(page).to have_content('Comment deleted!')
      end
    end
  end
end

def scroll_page
  page.scroll_to(0, 10000)
  sleep(0.4)
end
