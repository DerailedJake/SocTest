class CreateContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :contacts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :acquaintance, null: false, foreign_key: { to_table: :users }
      t.string :status, null: false, default: 'observed'

      t.index [:user_id, :acquaintance_id], unique: true
      t.timestamps
    end
  end
end
