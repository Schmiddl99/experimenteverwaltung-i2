class RecreateMediaTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :media
    create_table :media do |t|
      t.string :name
      t.string :media_type
      t.integer :sort, null: false
      t.belongs_to :experiment, foreign_key: true

      t.timestamps
    end
  end
end
