class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :notification_manager, null: false, foreign_key: true
      t.string :notification_type
      t.text :data

      t.timestamps
    end
  end
end
