require 'rails_helper'

RSpec.describe Post, type: :model do
  before do
    @user = create(:user)
    sleep(0.4)
  end
  subject { build(:post, user: @user) }
  it 'it should be valid with picture and body' do
    expect(subject).to be_valid
  end
  it 'it should be valid with body' do
    subject.picture = nil
    expect(subject).to be_valid
  end
  it 'it should not be valid without body' do
    subject.body = nil
    expect(subject).not_to be_valid
  end
  it 'it belongs to user' do
    subject.user = nil
    expect(subject).not_to be_valid
  end
  it 'it may belong to stories that belong to user' do
    3.times { create(:story, user: @user) }
    subject.story_ids = Story.all.ids
    expect(subject).to be_valid
  end
  it 'it may not belong to stories that belong to others' do
    3.times { create(:story) }
    subject.story_ids = Story.all.ids
    expect(subject).not_to be_valid
  end
  it 'it may have many comments' do
    3.times { create(:comment) }
    subject.comment_ids = Comment.all.ids
    expect(subject).to be_valid
  end
end
