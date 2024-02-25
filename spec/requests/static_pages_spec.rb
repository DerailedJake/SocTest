require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  before(:example) do
    3.times { create :user }
  end

  describe 'GET /landing' do
    it 'returns a success response' do
      get "/landing"
      expect(response).to be_successful
    end
  end

  describe 'GET /about' do
    it 'returns a success response' do
      get "/static_pages/about"
      expect(response).to be_successful
    end
  end

  describe 'GET /contact' do
    it 'returns a success response' do
      get "/static_pages/contact"
      expect(response).to be_successful
    end
  end

  describe 'GET /legal' do
    it 'returns a success response' do
      get "/static_pages/legal"
      expect(response).to be_successful
    end
  end
end