require 'rails_helper'

RSpec.describe "StaticPages", type: :request do

  describe 'GET /about' do
    it 'returns a success response' do
      get "/about"
      expect(response).to be_successful
    end
  end
end