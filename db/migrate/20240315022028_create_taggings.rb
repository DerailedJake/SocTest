class CreateTaggings < ActiveRecord::Migration[7.1]
  def change
    create_table :taggings do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :taggable, polymorphic: true, null: false

      t.index [:tag_id, :taggable_type, :taggable_id ], unique: true

      t.timestamps
    end
  end
end
