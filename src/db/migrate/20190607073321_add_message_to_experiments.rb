class AddMessageToExperiments < ActiveRecord::Migration[5.2]
  def change
    add_column :experiments, :message, :text
  end
end
