class CreateJoinTableExperimentDanger < ActiveRecord::Migration[5.2]
  def change
    create_join_table :experiments, :dangers do |t|
      t.index [:experiment_id, :danger_id]
    end
  end
end
