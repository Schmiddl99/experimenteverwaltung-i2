class AddAdhocToEquipment < ActiveRecord::Migration[5.2]
  def change
    add_column :equipment, :adhoc, :boolean, default: false
  end
end
