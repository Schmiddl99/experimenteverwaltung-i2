class CreateCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :courses do |t|
      t.string :name, index: { unique: true }, null: false

      t.timestamps
    end
  end
end
