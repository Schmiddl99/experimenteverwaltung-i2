class AddUsernameToUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :email, :string
    add_column :users, :username, :string
  end
end
