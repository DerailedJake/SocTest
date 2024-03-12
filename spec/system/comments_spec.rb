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
        expect(page).to have_content('End of comments!')
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
    within "#post-#{target_post.id}" do
      if has_comments
        expect(page).to have_content(target_post.comments.last.body)
        click_on('Show more comments')
        page.scroll_to(0, 10000)
        sleep(0.2)
        expect(page).to have_content(target_post.comments.first.body)
      else
        expect(page).to have_content('End of comments!')
      end
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
      12.times { @post.comments.create(attributes_for(:comment).merge(user: @second_user)) }
      sleep(1)
      12.times { @second_post.comments.create(attributes_for(:comment).merge(user: @current_user)) }
      sleep(1)
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
end
