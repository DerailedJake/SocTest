require 'rails_helper'

RSpec.describe Message, type: :model do
  subject { build :message }
  describe 'associations' do
    it{ should belong_to :user }
    it{ should belong_to :chat }
  end
  describe 'validations' do
    it { should validate_presence_of :content }
    it { should validate_length_of(:content).is_at_least(1) }
    it { should validate_length_of(:content).is_at_most(500) }
  end
end
