class AddCountToTags < ActiveRecord::Migration[7.1]
  def change
    add_column :tags, :taggable_count, :integer, default: 0
  end
end
