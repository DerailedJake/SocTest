class CreateChatParticipations < ActiveRecord::Migration[7.1]
  def change
    create_table :chat_participations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :chat, null: false, foreign_key: true

      t.index [:user_id, :chat_id], unique: true

      t.timestamps
    end
  end
end
