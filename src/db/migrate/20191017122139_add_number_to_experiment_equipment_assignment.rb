class AddNumberToExperimentEquipmentAssignment < ActiveRecord::Migration[5.2]
  def change
    add_column :experiment_equipment_assignments, :number, :integer, default: 1
  end
end
