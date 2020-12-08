class Category < ApplicationRecord
  has_many :sub_categories, dependent: :destroy
  validates :name, presence: true
  validates :label, presence: true

  scope :sorted, -> { order(:priority) }

  def prev
    Category.sorted.where("priority < ?", priority).last
  end

  def next
    Category.sorted.find_by("priority > ?", priority)
  end
end
