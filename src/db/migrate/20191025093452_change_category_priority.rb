class ChangeCategoryPriority < ActiveRecord::Migration[5.2]
  def data
    [3, 5, 6, 2, 4, 1].each_with_index{|id, i| Category.find(id).update(priority: i) }
  end
end
