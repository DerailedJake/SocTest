require 'rails_helper'

RSpec.describe Tag, type: :model do
  subject { build :tag }
  describe 'associations' do
    it{ should have_many :stories }
    it{ should have_many :posts }
  end
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
    it { should validate_length_of(:name).is_at_least(1) }
    it { should validate_length_of(:name).is_at_most(60) }
  end
end
