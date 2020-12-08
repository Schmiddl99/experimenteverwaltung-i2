class ChangeMedia < ActiveRecord::Migration[5.2]
  def change
  	rename_column :media, :type, :media_type
  end
end
