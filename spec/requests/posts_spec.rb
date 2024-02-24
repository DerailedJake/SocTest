require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /index" do
    pending "add some examples (or delete) #{__FILE__}"
  end
end



describe 'GET /contact' do
  it 'returns a success response' do
    get :contact
    expect(response).to be_successful
  end
end

describe 'GET /legal' do
  it 'returns a success response' do
    get :legal
    expect(response).to be_successful
  end
end



describe 'GET /landing' do
  it 'returns a success response' do
    get :landing
    @users = [User.first, User.second, User.last]
    expect(response).to be_successful
  end
end
