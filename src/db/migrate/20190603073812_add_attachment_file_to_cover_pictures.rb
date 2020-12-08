class AddAttachmentFileToCoverPictures < ActiveRecord::Migration[5.2]
  def self.up
    change_table :cover_pictures do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :cover_pictures, :file
  end
end
