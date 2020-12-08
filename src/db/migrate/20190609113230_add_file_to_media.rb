class AddFileToMedia < ActiveRecord::Migration[5.2]
  def self.up
    change_table :media do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :media, :file
  end
end
