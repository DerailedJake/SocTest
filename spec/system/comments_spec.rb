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
    page.scroll_to(0, 10000)
    sleep(0.2)
    within "#post-comments-#{target_post.id}" do
      if has_comments
        expect(page).to have_content(target_post.comments.last.body)
        click_on('Show more comments')
        page.scroll_to(0, 10000)
        sleep(0.2)
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
      page.scroll_to(0, 10000)
      sleep(0.2)
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
  # target_post has_stories stories[]
  before do
    @valid_comment_body = 'A perfectly fine comment.'
  end
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
  it 'can create new comments' do
    within modal_name do
      expect(page).to have_content('Write a comment...')
      fill_in 'comment[body]', with: @valid_comment_body
      click_on('Comment')
      expect(page).to have_content('Comment created!')
      expect(page).to have_content(@valid_comment_body)
    end
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
      @post.comments.update_all(user: @current_user)
    end
    context 'in modal' do
      it 'updates comment' do
        visit profile_path(@current_user)
        within "#post-#{@post.id}" do
          click_on 'Show comments!'
        end
        within "#commentsModal-#{@post.id}" do
          expect(page).to have_content('Update')
          expect(page).to have_content(@post.comments.last.body)
          click_on 'Update'
          expect(page).to have_content('Comment updated!')
          expect(page).not_to have_content(@post.comments.last.body)
        end
      end
    end
    context 'in post page' do
      it 'updates comment' do
        visit post_path(@post)
        within "#post-#{@post.id}" do
          click_on 'Show comments!'
        end
        within "#commentsModal-#{@post.id}" do
          expect(page).to have_content('Update')
          expect(page).to have_content(@post.comments.last.body)
          click_on 'Update'
          expect(page).to have_content('Comment updated!')
          expect(page).not_to have_content(@post.comments.last.body)
        end
      end
    end
  end

  describe 'DELETE' do
    before do
      @post = @current_user.posts.last
      login_as(@current_user)
      @post.comments.update_all(user: @current_user)
    end
    context 'in modal' do
      it 'delete comment' do
        visit profile_path(@current_user)
        within "#post-#{@post.id}" do
          click_on 'Show comments!'
        end
        within "#commentsModal-#{@post.id}" do
          expect(page).to have_content('Delete')
          expect(page).to have_content(@post.comments.last.body)
          click_on 'Delete'
          expect(page).to have_content('Comment deleted!')
          expect(page).not_to have_content(@post.comments.last.body)
        end
      end
    end
    context 'in post page' do
      it 'delete comment' do
        visit post_path(@post)
        within "#post-#{@post.id}" do
          click_on 'Show comments!'
        end
        within "#commentsModal-#{@post.id}" do
          expect(page).to have_content('Delete')
          expect(page).to have_content(@post.comments.last.body)
          click_on 'Delete'
          expect(page).to have_content('Comment deleted!')
          expect(page).not_to have_content(@post.comments.last.body)
        end
      end
    end
  end
end
