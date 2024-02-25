require 'rails_helper'

RSpec.describe "Users", type: :request do
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
        get users_home_path
        expect(response).to be_successful
      end
    end

    describe 'GET /index' do
      it 'returns a success response' do
        get users_index_path
        expect(response).to be_successful
      end
    end

    describe 'GET /profile' do
      it 'returns a success response' do
        get profile_path(@user.id)
        expect(response).to be_successful
      end
    end
  end

  context 'when user logged out' do
    describe 'GET /home' do
      it 'returns a success response' do
        get users_home_path
        expect(response).not_to be_successful
      end
    end

    describe 'GET /index' do
      it 'returns a success response' do
        get users_index_path
        expect(response).to be_successful
      end
    end

    describe 'GET /profile' do
      it 'returns a success response' do
        get profile_path(@user.id)
        expect(response).to be_successful
      end
    end
  end
end
