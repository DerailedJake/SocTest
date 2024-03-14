require 'rails_helper'

RSpec.shared_examples 'like comment' do
  # target_comment likes_count
  it 'shows comments' do
    within "#turbo-like-Comment-#{target_comment.id}" do
      expect(page).to have_selector('a')
      expect(page).to have_content(likes_count)
      click_on ''
      expect(page).to have_content(likes_count + 1)
      click_on ''
      expect(page).to have_content(likes_count)
    end
  end
end

RSpec.describe 'Like', type: :system do
  before do
    @current_user = users_with_stories_posts_comments_and_likes
    @second_user = User.second
    @post = @current_user.posts.last
    @second_post = @second_user.posts.last
    @comment = @post.comments.last
    @second_comment = @post.comments.first
    @story = @current_user.stories.last
  end
  describe 'liking comments' do
    context 'while logged IN' do
      before do
        login_as(@current_user)
      end
      context 'on comment' do
        it 'likes properly' do
          visit root_path
          within "#post-#{@post.id}" do
            click_on 'Show comments!'
          end
          check_liking_comment(@comment.id, 'Comment')
          check_liking_comment(@second_comment.id, 'Comment')
        end
      end
      context 'on posts' do
        it 'likes properly' do
          visit post_path(@post)
          page.scroll_to(0, 10000)
          sleep(0.5)
          check_liking_comment(@comment.id, 'Comment')
          check_liking_comment(@second_comment.id, 'Comment')
        end
      end
      context 'on stories' do
        it 'likes properly' do
          visit story_path(@story)
          within "#post-#{@post.id}" do
            click_on 'Show comments!'
          end
          check_liking_comment(@comment.id, 'Comment')
          check_liking_comment(@second_comment.id, 'Comment')
        end
      end
    end
    context 'while logged OUT' do
      context 'on comment' do
        it 'shows likes' do
          visit profile_path(@current_user)
          within "#post-#{@post.id}" do
            click_on 'Show comments!'
          end
          check_likes_display(@comment.id, 'Comment')
          check_likes_display(@second_comment.id, 'Comment')
        end
      end
      context 'on posts' do
        it 'shows likes' do
          visit post_path(@post)
          page.scroll_to(0, 10000)
          sleep(0.5)
          check_likes_display(@comment.id, 'Comment')
          check_likes_display(@second_comment.id, 'Comment')
        end
      end
      context 'on stories' do
        it 'shows likes' do
          visit story_path(@story)
          within "#post-#{@post.id}" do
            click_on 'Show comments!'
          end
          check_likes_display(@comment.id, 'Comment')
          check_likes_display(@second_comment.id, 'Comment')
        end
      end
    end
  end

  describe 'liking posts' do
    context 'while logged IN' do
      before do
        login_as(@current_user)
      end
      context 'in profile' do
        it 'likes properly' do
          visit root_path
          check_liking_comment(@post.id, 'Post')
        end
      end
      context 'in post view' do
        it 'likes properly' do
          visit post_path(@post)
          page.scroll_to(0, 10000)
          sleep(0.5)
          check_liking_comment(@post.id, 'Post')
        end
      end
      context 'in story view' do
        it 'likes properly' do
          visit story_path(@story)
          check_liking_comment(@post.id, 'Post')
        end
      end
    end
    context 'while logged OUT' do
      context 'on comment' do
        it 'shows likes' do
          visit profile_path(@current_user)
          check_likes_display(@post.id, 'Post')
        end
      end
      context 'on posts' do
        it 'shows likes' do
          visit post_path(@post)
          page.scroll_to(0, 10000)
          sleep(0.5)
          check_likes_display(@post.id, 'Post')
        end
      end
      context 'on stories' do
        it 'shows likes' do
          visit story_path(@story)
          check_likes_display(@post.id, 'Post')
        end
      end
    end
  end

  describe 'liking stories' do
    context 'while logged IN' do
      before do
        login_as(@current_user)
      end
      context 'in profile' do
        it 'likes properly' do
          visit root_path
          check_liking_comment(@story.id, 'Story')
        end
      end
      context 'in post view' do
        it 'likes properly' do
          visit post_path(@post)
          page.scroll_to(0, 10000)
          sleep(0.7)
          page.scroll_to(0, 10000)
          sleep(0.4)
          check_liking_comment(@story.id, 'Story')
        end
      end
      context 'in story view' do
        it 'likes properly' do
          visit story_path(@story)
          check_liking_comment(@story.id, 'Story')
        end
      end
    end
    context 'while logged OUT' do
      context 'on comment' do
        it 'shows likes' do
          visit profile_path(@current_user)
          check_likes_display(@story.id, 'Story')
        end
      end
      context 'on posts' do
        it 'shows likes' do
          visit post_path(@post)
          page.scroll_to(0, 10000)
          sleep(0.7)
          page.scroll_to(0, 10000)
          sleep(0.4)
          check_likes_display(@story.id, 'Story')
        end
      end
      context 'on stories' do
        it 'shows likes' do
          visit story_path(@story)
          check_likes_display(@story.id, 'Story')
        end
      end
    end
  end

  def check_liking_comment(target_id, type, likes_count = 3)
    within "#turbo-like-#{type}-#{target_id}" do
      expect(page).to have_selector('a')
      expect(page).to have_content(likes_count)
      click_on ''
      expect(page).to have_content(likes_count - 1)
      click_on ''
      expect(page).to have_content(likes_count)
    end
  end

  def check_likes_display(target_id, type, likes_count = 3)
    within "#turbo-like-#{type}-#{target_id}" do
      expect(page).not_to have_selector('a')
      expect(page).to have_content(likes_count)
    end
  end
end
