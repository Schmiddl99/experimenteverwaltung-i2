class RemoveJoinTableExperimentDanger < ActiveRecord::Migration[6.1]
  def change
    drop_join_table :experiments, :dangers
  end
end
