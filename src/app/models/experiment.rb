class Experiment < ApplicationRecord
  belongs_to :sub_category
  belongs_to :user
  has_many :videos, dependent: :destroy
  has_many :links, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :media, dependent: :destroy
  has_many :experiment_equipment_assignments, dependent: :destroy
  has_many :equipment, through: :experiment_equipment_assignments, dependent: :destroy
  has_many :experiment_danger_assignments, dependent: :destroy
  has_many :dangers, through: :experiment_danger_assignments, dependent: :destroy
  validates :name, presence: true
  validates :label, presence: true, uniqueness: true
  validates :description, presence: true

  scope :active, -> { where(deleted: false) }
  scope :deleted, -> { where(deleted: true) }
  scope :sorted, -> { order(:label) }

  accepts_nested_attributes_for :media, allow_destroy: false, reject_if: :reject_if_file
  accepts_nested_attributes_for :links, allow_destroy: true, reject_if: :reject_if_url
  accepts_nested_attributes_for :videos, allow_destroy: true, reject_if: :reject_if_file
  accepts_nested_attributes_for :documents, allow_destroy: true, reject_if: :reject_if_file
  accepts_nested_attributes_for :experiment_equipment_assignments, allow_destroy: true, reject_if: :reject_if_equipment
  accepts_nested_attributes_for :experiment_danger_assignments, allow_destroy: true, reject_if: :reject_if_danger

  before_validation :set_sub_category

  def build_relationships
    videos.build
    links.build
    documents.build
    media.build
    experiment_danger_assignments.build
    experiment_equipment_assignments.build
  end

  def set_sub_category
    sc_label = label.try(:split, ".").try(:first)
    self.sub_category = SubCategory.find_by(label: sc_label) || sub_category
  end

  def reject_if_equipment(attributes)
    attributes['equipment_id'].blank?
  end

  def reject_if_danger(attributes)
    attributes['danger_id'].blank?
  end

  def reject_if_file(attributes)
    attributes['file'].blank?
  end

  def reject_if_url(attributes)
    attributes['url'].blank?
  end

  def prev
    Experiment.sorted.where("sub_category_id = ? AND label < ?", sub_category_id, label).where(deleted: false).last
  end

  def next
    Experiment.sorted.where("sub_category_id = ? AND label > ?", sub_category_id, label).find_by(deleted: false)
  end

  def name_with_label
    "#{label} - #{name}"
  end
end
