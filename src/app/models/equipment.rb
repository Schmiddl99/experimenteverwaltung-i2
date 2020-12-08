class Equipment < ApplicationRecord
  has_many :experiment_equipment_assignments, dependent: :destroy
  has_many :experiments, through: :experiment_equipment_assignments, dependent: :destroy
  validates :name, presence: true
  validates :location, presence: true

  def self.collection(experiment = nil)
    ids = if experiment.try(:id).present?
            experiment.experiment_equipment_assignments.pluck(:equipment_id)
          else
            []
          end
    [["+++ Neues Gerät anlegen +++", "new"]] + where(adhoc: false)
      .or(Equipment.where(id: ids))
      .order(Arel.sql("lower(name)")).map { |e| [e.name, e.id] }
  end
end
