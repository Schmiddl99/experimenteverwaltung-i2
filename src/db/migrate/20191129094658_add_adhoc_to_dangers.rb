class AddAdhocToDangers < ActiveRecord::Migration[5.2]
  def change
    add_column :dangers, :adhoc, :boolean, default: false
  end
end
