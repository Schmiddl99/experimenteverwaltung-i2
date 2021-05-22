class CreateDummyExperiments < ActiveRecord::Migration[6.1]
  def change
    create_table :dummy_experiments do |t|
      t.string :name

      t.timestamps
    end
  end
end
