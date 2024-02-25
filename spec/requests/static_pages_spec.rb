require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  before(:example) do
    3.times { create :user }
  end

  describe 'GET /landing' do
    it 'returns a success response' do
      get static_pages_landing_path
      expect(response).to be_successful
    end
  end

  describe 'GET /about' do
    it 'returns a success response' do
      get static_pages_about_path
      expect(response).to be_successful
    end
  end

  describe 'GET /contact' do
    it 'returns a success response' do
      get static_pages_contact_path
      expect(response).to be_successful
    end
  end

  describe 'GET /legal' do
    it 'returns a success response' do
      get static_pages_legal_path
      expect(response).to be_successful
    end
  end
end