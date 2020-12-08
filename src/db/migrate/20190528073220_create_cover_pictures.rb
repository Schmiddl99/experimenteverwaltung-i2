class CreateCoverPictures < ActiveRecord::Migration[5.2]
  def change
    create_table :cover_pictures do |t|
      t.boolean :current, default: false

      t.timestamps
    end
  end
end
