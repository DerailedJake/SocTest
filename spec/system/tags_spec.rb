require 'rails_helper'

RSpec.shared_examples 'tags display' do
  # target_tag
  it 'should properly show tags' do
    visit tags_path
    num = target_tag.taggings.count
    expect(page).to have_content "#{target_tag.name} - #{num}"
    click_on target_tag.name
    sleep(0.3) # its way too fast
    expect(page).to have_current_path show_tag_path(target_tag.name)
    expect(page).to have_content target_tag.name
    if target_tag.posts.any?
      expect(page).to have_content target_tag.posts.first.body
    else
      expect(page).to have_content 'No tagged posts'
    end
    if target_tag.stories.any?
      expect(page).to have_content target_tag.stories.first.description
    else
      expect(page).to have_content 'No tagged stories'
    end
  end
end

RSpec.shared_examples 'count taggables' do |taggable, text|
  it 'changes properly' do
    visit tags_path
    expect(page).to have_content "#{@tag_name} - #{@count}"
    if taggable == 'post'
      visit new_post_path
      fill_in 'post[body]', with: text
    else
      visit new_story_path
      fill_in 'story[title]', with: text
    end
    add_tag(@tag_name)
    click_on 'Create'
    expect(page).to have_content 'created'
    visit tags_path
    expect(page).to have_content "#{@tag_name} - #{@count + 1}"
    click_on @tag_name
    expect(page).to have_content text
  end
end

RSpec.shared_examples 'search tag form' do
  it 'it lists tags properly' do
    fill_in 'tag_name', with: 'e'
    sleep(0.3)
    expect(page).to have_content @tag_name
    expect(page).to have_content @another_tag_name
  end
  it 'should find, add and remove tags' do
    add_tag(@tag_name)
    add_tag(@another_tag_name)
    expect(page).to have_content @tag_name
    expect(page).to have_content @another_tag_name
    remove_tag(@tag_name)
    expect(page).not_to have_content @tag_name
    remove_tag(@another_tag_name)
    expect(page).not_to have_content @another_tag_name
  end
end

RSpec.describe 'Tags', type: :system do
  before do
    @current_user = user_with_posts_and_stories(object_count: 3)
    create(:tag, name: 'FirstOne')
    create(:tag, name: 'SecondOne')
    @first_tag = Tag.first
    @second_tag = Tag.second
    tag_ids = [@first_tag.id]
    @current_user.posts.each do |post|
      post.update(tag_ids: tag_ids)
    end
    @current_user.stories.each do |story|
      story.update(tag_ids: tag_ids)
    end
  end

  context 'index and show' do
    context 'when logged in' do
      before do
        login_as @current_user
      end
      context 'with taggables' do
        include_examples 'tags display' do
          let(:target_tag) { @first_tag }
        end
      end
      context 'without taggables' do
        include_examples 'tags display' do
          let(:target_tag) { @second_tag }
        end
      end
    end

    context 'when logged out' do
      context 'with taggables' do
        include_examples 'tags display' do
          let(:target_tag) { @first_tag }
        end
      end
      context 'without taggables' do
        include_examples 'tags display' do
          let(:target_tag) { @second_tag }
        end
      end
    end
  end

  context 'links' do
    before do
      @post = @current_user.posts.last
      @story = @current_user.stories.first
      @story.update(post_ids: [@post.id])
      @tag_name = @first_tag.name
    end
    it 'from profile redirect to tag' do
      visit profile_path(@current_user)
      sleep(0.3)
      click_on @tag_name, match: :first
      expect(page).to have_current_path show_tag_path(@tag_name)
    end
    it 'from post redirect to tag' do
      visit post_path(@post)
      sleep(0.3)
      click_on @tag_name, match: :first
      expect(page).to have_current_path show_tag_path(@tag_name)
    end
    it 'from story redirect to tag' do
      visit story_path(@story)
      sleep(0.3)
      click_on @tag_name, match: :first
      expect(page).to have_current_path show_tag_path(@tag_name)
    end
  end

  describe 'tagging in post' do
    context 'new post' do
      before do
        @tag_name = 'Abcdefgh'
        create(:tag, name: @tag_name)
        login_as @current_user
        visit new_post_path
        fill_in 'post[body]', with: 'Valid post body'
      end
      it 'should create post with tag' do
        add_tag(@tag_name)
        click_on 'Create'
        expect(page).to have_content 'Post created'
        expect(page).to have_content @tag_name
      end
    end
    context 'editing post' do
      before do
        @tag_name = 'Abcdefgh'
        @another_tag_name = 'Qwertyuio'
        create(:tag, name: @another_tag_name)
        @tag = create(:tag, name: @tag_name)
        @current_user.posts.create(attributes_for(:post).merge(tag_ids: [@tag.id]))
        @post = @current_user.posts.last
        login_as @current_user
        visit edit_post_path(@post)
      end
      it 'should remove and add tags properly' do
        add_tag(@another_tag_name)
        remove_tag(@tag_name)
        click_on 'Update'
        expect(page).to have_content 'Post updated'
        expect(page).to have_content @another_tag_name
        expect(page).not_to have_content @tag_name
      end
    end
  end

  describe 'tagging in story' do
    context 'new story' do
      before do
        @tag_name = 'Abcdefgh'
        create(:tag, name: @tag_name)
        login_as @current_user
        visit new_story_path
        fill_in 'story[title]', with: 'Valid story title'
      end
      it 'should create post with tag' do
        add_tag(@tag_name)
        click_on 'Create'
        expect(page).to have_content 'Story created'
        expect(page).to have_content @tag_name
      end
    end
    context 'editing post' do
      before do
        @tag_name = 'Abcdefgh'
        @another_tag_name = 'Qwertyuio'
        create(:tag, name: @another_tag_name)
        @tag = create(:tag, name: @tag_name)
        @current_user.stories.create(attributes_for(:story).merge(tag_ids: [@tag.id]))
        @story = @current_user.stories.last
        login_as @current_user
        visit edit_story_path(@story)
      end
      it 'should remove and add tags properly' do
        add_tag(@another_tag_name)
        remove_tag(@tag_name)
        click_on 'Update'
        expect(page).to have_content 'Story updated'
        expect(page).to have_content @another_tag_name
        expect(page).not_to have_content @tag_name
      end
    end
  end

  describe 'search tag form' do
    before do
      @tag_name = 'Abcdefgh'
      @another_tag_name = 'Qwertyuio'
      create(:tag, name: @tag_name)
      create(:tag, name: @another_tag_name)
      login_as @current_user
    end
    context 'in story form' do
      before do
        visit new_post_path
        fill_in 'post[body]', with: 'Valid post body'
      end
      include_examples 'search tag form'
    end
    context 'in post form' do
      before do
        visit new_story_path
        fill_in 'story[title]', with: 'Valid story title'
      end
      include_examples 'search tag form'
    end
  end

  describe 'counter of taggables' do
    before do
      @tag_name = 'Abcdefgh'
      create(:tag, name: @tag_name)
      @count = 0
      login_as @current_user
    end
    context 'for posts' do
      include_examples 'count taggables', 'post', 'Valid post body'
    end
    context 'for stories' do
      include_examples 'count taggables', 'story', 'Valid story title'
    end
  end

  def add_tag(tag_name)
    fill_in 'tag_name', with: tag_name[0..2]
    click_on tag_name
  end

  def remove_tag(tag_name)
    selector = "tag-in-form-#{tag_name}"
    within "##{selector}" do
      find('a').click
    end
  end
end
