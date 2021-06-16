# A custom experiment used for exactly one order.
#
# @author Richard Böhme
class DummyExperiment < ApplicationRecord
  validates :name, presence: true
end
