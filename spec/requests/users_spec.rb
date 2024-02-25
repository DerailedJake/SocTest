require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:valid_attributes) {
    { email: 'john@example.com', password: 'qwerqwer' }
  }

  let(:invalid_attributes) {
    { email: 'invalid_email' }
  }

  before(:context) do
    @current_user = create(:user)
    @user = create(:user)
    @user2 = create(:user)
    @user3 = create(:user)
  end

  context 'when user logged in' do
    before(:example) do
      sign_in @current_user
    end

    describe 'GET /home' do
      it 'returns a success response' do
        get '/users/home'
        expect(response).to be_successful
      end
    end

    describe 'GET /index' do
      it 'returns a success response' do
        get '/'
        expect(response).to be_successful
      end
    end

    describe 'GET /profile' do
      it 'returns a success response' do
        get "/users/profile/#{@user.id}"
        expect(response).to be_successful
      end
    end
  end

  context 'when user logged out' do
    describe 'GET /home' do
      it 'returns a success response' do
        get '/'
        expect(response).not_to be_successful
      end
    end

    describe 'GET /index' do
      it 'returns a success response' do
        get '/users/index'
        expect(response).to be_successful
      end
    end

    describe 'GET /profile' do
      it 'returns a success response' do
        get "/users/profile/#{@user.id}"
        expect(response).to be_successful
      end
    end
  end
end
