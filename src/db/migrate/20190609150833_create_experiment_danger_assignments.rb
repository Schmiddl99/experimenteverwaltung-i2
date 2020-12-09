class CreateExperimentDangerAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :experiment_danger_assignments do |t|
      t.belongs_to :danger, foreign_key: true
      t.belongs_to :experiment, foreign_key: true

      t.timestamps
    end
  end
end
