require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:valid_attributes) {
    { body: Faker::Lorem.sentence(word_count: 10) }
  }
  let(:invalid_attributes) {
    { body: '' }
  }
  before(:example) do
    @user = create(:user)
    sign_in(@user)
  end

  describe 'GET /new' do
    it 'returns a success response' do
      get new_post_path
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Post' do
        expect {
          post posts_path, params: { post: valid_attributes }
        }.to change(Post, :count).by(1)
      end

      it 'redirects to the created Post' do
        post posts_path, params: { post: valid_attributes }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid params' do
      it 'redirects back' do
        post posts_path, params: { post: invalid_attributes }
        expect(response).to have_http_status('422')
      end
    end

    context 'while logged out' do
      it 'should ' do
        post posts_path, params: { post: valid_attributes}
        expect(response).not_to be_successful
      end
    end
  end
end
