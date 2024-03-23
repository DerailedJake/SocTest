class CreateNotificationManagers < ActiveRecord::Migration[7.1]
  def change
    create_table :notification_managers do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.text :settings

      t.timestamps
    end
  end
end
