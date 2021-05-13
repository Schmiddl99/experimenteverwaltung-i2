class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :course, null: false, index: true
      t.string :alternative_course_name
      t.datetime :course_at
      t.string :comment
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
