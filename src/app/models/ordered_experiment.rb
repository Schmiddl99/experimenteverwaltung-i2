# Join model between {Order} and {Experiment} that also contains the
# experiment's order in a course/order.
#
# @author Richard Böhme
class OrderedExperiment < ApplicationRecord
  belongs_to :order
  belongs_to :experiment, polymorphic: true

  scope :sorted, ->() { order(:sort) }

  before_destroy do
    if dummy_experiment?
      experiment.destroy
    end
  end

  # Checks whether the experiment that should be ordered is a
  # dummy experiment.
  #
  # @author Richard Böhme
  # @return [Boolean]
  def dummy_experiment?
    experiment_type == "DummyExperiment"
  end
end
