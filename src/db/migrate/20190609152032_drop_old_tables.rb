class DropOldTables < ActiveRecord::Migration[5.2]
  def change
    drop_table :equipment_experiments
  end
end
