class AddPriorityToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :priority, :integer, default: 0
  end
end
