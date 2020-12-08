class SubCategory < ApplicationRecord
  belongs_to :category
  has_many :experiments, dependent: :destroy
  validates :name, presence: true
  validates :label, presence: true

  def prev
    SubCategory.where(category_id: category_id).where("id < ?", id).last
  end

  def next
    SubCategory.where(category_id: category_id).find_by("id > ?", id)
  end
end
