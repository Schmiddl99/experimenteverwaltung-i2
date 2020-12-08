class CreateExperiments < ActiveRecord::Migration[5.2]
  def change
    create_table :experiments do |t|
      t.string :name
      t.string :label
      t.belongs_to :sub_category, foreign_key: true
      t.text :description
      t.boolean :deleted, default: false
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
