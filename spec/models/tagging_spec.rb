require 'rails_helper'

RSpec.describe Tagging, type: :model do
  subject { build :tagging }
  describe 'associations' do
    it{ should belong_to :tag }
    it{ should belong_to :taggable }
  end
end
