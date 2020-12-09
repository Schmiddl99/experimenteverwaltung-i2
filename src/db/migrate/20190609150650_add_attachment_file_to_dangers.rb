class AddAttachmentFileToDangers < ActiveRecord::Migration[5.2]
  def up
    add_attachment :dangers, :file
  end

  def down
    remove_attachment :dangers, :file
  end
end
