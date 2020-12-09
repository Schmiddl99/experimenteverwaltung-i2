class AddSortingNrToMedia < ActiveRecord::Migration[5.2]
  def change
    add_column :media, :sorting_nr, :integer
    drop_table :experiment_medium_assignments
  end
end
