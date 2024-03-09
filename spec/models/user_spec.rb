require 'rails_helper'

RSpec.describe User, type: :model do
  before { sleep(1) } # pg issues
  subject { build(:user) }
  describe 'associations' do
    it
  end
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:category_id) }
  end
  it 'it should be valid with no description' do
    subject.description = nil
    expect(subject).to be_valid
  end
  it 'it should not be valid with no avatar' do
    subject.avatar = nil
    expect(subject).not_to be_valid
  end
  it 'it should not be valid with first name' do
    subject.first_name = nil
    expect(subject).not_to be_valid
  end
  it 'it should not be valid with last name' do
    subject.last_name = nil
    expect(subject).not_to be_valid
  end
  it 'it may has many stories that belong to user' do
    3.times { create(:story) }
    subject.story_ids = Story.all.ids
    expect(subject).to be_valid
  end
  it 'it may has many posts that belong to user' do
    3.times { create(:post) }
    subject.post_ids = Post.all.ids
    expect(Post.first.user).to eq(subject)
    expect(subject.post_ids).to eq(1)
    expect(subject).to be_valid
  end
  it 'it may has many comments that belong to user' do
    3.times { create(:comment) }
    subject.comment_ids = Comment.all.ids
    expect(subject).to be_valid
  end
  it 'full_name should work properly' do
    subject.first_name = 'One'
    subject.last_name = 'Two'
    expect(subject.full_name).to eq('One Two')
  end
end
