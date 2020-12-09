class CreateJoinTableExperimentEquipment < ActiveRecord::Migration[5.2]
  def change
    create_join_table :experiments, :equipment do |t|
      t.index [:experiment_id, :equipment_id]
    end
  end
end
