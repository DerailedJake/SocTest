class AddLikesCountToPostsAndStories < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :likes_count, :integer, default: 0
    add_column :stories, :likes_count, :integer, default: 0
  end
end
