class Danger < ApplicationRecord
  has_many :experiment_danger_assignments, dependent: :destroy
  has_many :experiments, through: :experiment_danger_assignments, dependent: :destroy
  validates :name, presence: true
  validates :label, presence: true
  has_attached_file :file,
    styles: { medium: ["300x300^", "png"], thumb: ["100x100^", "png"] },
    path: ":rails_root/public/uploads/dangers/:style/:id.:extension",
    url: "/uploads/dangers/:style/:id.:extension"
  validates_attachment :file, content_type: { content_type: ["image/png", "image/jpg", "image/jpeg"] }

  def self.collection(experiment = nil)
    [["+++ Neue Gefahr anlegen +++", "new"]] + order("name").map { |e| [e.name, e.id] }
  end
end
