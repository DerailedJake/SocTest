class AddObservedToContacts < ActiveRecord::Migration[7.1]
  def change
    add_column :contacts, :observed, :string, default: 'SP'
    change_column :contacts, :status, :string, default: 'stranger', null: false
  end
end
