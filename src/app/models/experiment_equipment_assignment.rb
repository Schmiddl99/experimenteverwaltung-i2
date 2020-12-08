class ExperimentEquipmentAssignment < ApplicationRecord
  belongs_to :equipment
  belongs_to :experiment

  scope :sorted, -> { joins(:equipment).order(Arel.sql('lower(equipment.name)')) }
end
