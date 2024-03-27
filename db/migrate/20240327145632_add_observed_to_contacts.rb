class AddObservedToContacts < ActiveRecord::Migration[7.1]
  def change
    add_column :contacts, :observed, :string, default: 'SP'
  end
end
