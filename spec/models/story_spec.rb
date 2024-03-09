require 'rails_helper'

RSpec.describe Story, type: :model do
  before do
    @user = create(:user)
    sleep(0.1)
  end
  subject { build(:story, user: @user) }
  it 'it should be valid with title and body' do
    expect(subject).to be_valid
  end
  it 'it should be valid with title' do
    subject.description = nil
    expect(subject).to be_valid
  end
  it 'it should not be valid without title' do
    subject.title = nil
    expect(subject).not_to be_valid
  end
  it 'it belongs to user' do
    subject.user = nil
    expect(subject).not_to be_valid
  end
  it 'it may has many posts that belong to user' do
    3.times { create(:post, user: @user) }
    subject.post_ids = Post.all.ids
    expect(subject).to be_valid
  end
  it 'it may not belong to stories that belong to others' do
    3.times { create(:post) }
    subject.post_ids = Post.all.ids
    expect(subject).not_to be_valid
  end
end
