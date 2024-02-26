require 'rails_helper'

RSpec.describe "Stories", type: :request do
  let(:valid_attributes) {
    { title: Faker::Lorem.sentence(word_count: 3),
      description: Faker::Lorem.sentence(word_count: 10) }
  }
  let(:invalid_attributes) {
    { title: '',
      description: Faker::Lorem.sentence(word_count: 10) }
  }
  before(:example) do
    @current_user = create(:user)
    sign_in(@current_user)
  end

  describe 'GET /new' do
    it 'returns a success response' do
      get new_story_path
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Story' do
        expect {
          post stories_path, params: { story: valid_attributes }
        }.to change(Story, :count).by(1)
      end

      it 'redirects to the created Story' do
        post stories_path, params: { story: valid_attributes }
        expect(response).to redirect_to(story_path(Story.last.id))
      end
    end

    context 'with invalid params' do
      it 'redirects back' do
        post stories_path, params: { story: invalid_attributes }
        expect(response).to have_http_status('422')
      end
    end

    context 'while logged out' do
      it 'should not work' do
        post posts_path, params: { story: valid_attributes}
        expect(response).not_to be_successful
      end
    end
  end

  describe 'GET #edit' do
    before(:example) do
      @current_user.stories.create(attributes_for(:story))
      @story = @current_user.stories.last
    end

    context 'when logged in' do
      it 'shows the Story' do
        get edit_story_path(@story)
        expect(response).to be_successful
      end
    end

    context 'when logged out' do
      it 'redirects back' do
        sign_out(@current_user)
        get edit_story_path(@story)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PUT #update' do
    before(:example) do
      @current_user.stories.create(attributes_for(:story))
      @story = @current_user.stories.last
    end

    context 'with valid params' do
      it 'updates the Story' do
        put story_path(@story), params: { id: @story, story: { title: 'New name' } }
        expect(@story.reload.title).to eq 'New name'
      end

      it 'redirects to the Story' do
        put story_path(@story), params: { id: @story, story: { title: 'New name' } }
        expect(response).to redirect_to(story_path(@story))
      end
    end

    context 'with invalid params' do
      it 'redirects back' do
        put story_path(@story), params: { id: @story, story: { title: '' } }
        expect(response).to redirect_to(edit_story_path(@story))
      end
    end

    context 'while logged out' do
      it 'should not work' do
        sign_out(@current_user)
        put story_path(@story), params: { id: @story, story: { title: 'New name' } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
