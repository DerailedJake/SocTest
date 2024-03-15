class AddLikesCountToComments < ActiveRecord::Migration[7.1]
  def change
    add_column :comments, :likes_count, :integer, default: 0

    Comment.find_each do |comment|
      Comment.reset_counters comment.id, :likes
    end
  end
end
