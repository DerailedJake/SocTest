class PostsAndStories < ActiveRecord::Migration[7.1]
  def change
    create_table :posts_stories, id: false do |t|
      t.belongs_to :post
      t.belongs_to :story
    end
  end
end
