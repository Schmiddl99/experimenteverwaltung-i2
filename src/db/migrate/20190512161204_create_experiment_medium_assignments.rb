class CreateExperimentMediumAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :experiment_medium_assignments do |t|
      t.integer :sorting_nr
      t.belongs_to :medium, foreign_key: true
      t.belongs_to :experiment, foreign_key: true

      t.timestamps
    end
  end
end
