require 'rails_helper'

RSpec.describe Chat, type: :model do
  subject { build :chat }
  describe 'associations' do
    it{ should have_many :users }
    it{ should have_many :messages }
  end
  describe 'validations' do
    it { should validate_presence_of :title }
  end
end
