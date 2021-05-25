class CreateOrderedExperiments < ActiveRecord::Migration[6.1]
  def change
    create_table :ordered_experiments do |t|
      t.references :order, null: false, foreign_key: true
      t.references :experiment, polymorphic: true, null: false
      t.integer :sort, null: false
      t.index [:order_id, :experiment_id, :experiment_type], unique: true, name: "unique_ordered_experiment"
      t.index [:order_id, :sort], unique: true, name: "unique_experiment_sort"

      t.timestamps
    end
  end
end
