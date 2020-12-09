class AddAttachmentToMedia < ActiveRecord::Migration[5.2]
  def up
    add_attachment :media, :file
  end

  def down
    remove_attachment :media, :file
  end
end
