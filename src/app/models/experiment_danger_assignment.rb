class ExperimentDangerAssignment < ApplicationRecord
  belongs_to :danger
  belongs_to :experiment
end
