require 'rails_helper'

RSpec.describe "Stories", type: :request do
  let(:valid_attributes) {
    { title: Faker::Lorem.sentence(word_count: 10),
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

  describe 'GET /show' do
    it 'returns a success response' do
      get new_story_path
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Story' do
        expect {
          post stories_path, params: { post: valid_attributes }
        }.to change(Story, :count).by(1)
      end

      it 'redirects to the created Story' do
        post stories_path, params: { post: valid_attributes }
        expect(response).to redirect_to(story_path(Story.last.id))
      end
    end

    context 'with invalid params' do
      it 'redirects back' do
        post stories_path, params: { post: invalid_attributes }
        expect(response).to have_http_status('422')
      end
    end

    context 'while logged out' do
      it 'should not work' do
        post posts_path, params: { post: valid_attributes}
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
        get stories_path(@story.id)
        expect(response).to be_successful
      end
    end

    context 'when logged out' do
      before(:example) do
        sign_out
      end

      it 'redirects back' do
        post stories_path, params: { post: invalid_attributes }
        expect(response).to redirect_to(root_path)
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
        expect {
          put stories_path, params: { id: @story.id, story: valid_attributes }
        }.to change(Story, :count).by(1)
      end

      it 'redirects to the Story' do
        post stories_path, params: { id: @story.id, story: valid_attributes }
        expect(response).to redirect_to(story_path(Story.last.id))
      end
    end

    context 'with invalid params' do
      it 'redirects back' do
        post stories_path, params: { post: invalid_attributes }
        expect(response).to have_http_status('422')
      end
    end

    context 'while logged out' do
      it 'should not work' do
        post posts_path, params: { post: valid_attributes}
        expect(response).not_to be_successful
      end
    end
  end
end
