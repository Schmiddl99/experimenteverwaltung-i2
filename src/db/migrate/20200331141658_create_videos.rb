class CreateVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :videos do |t|
      t.belongs_to :experiment, foreign_key: true
      t.attachment :file

      t.timestamps
    end
  end
end
