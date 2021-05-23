# Join model between {Order} and {Experiment} that also contains the
# experiment's order in a course/order.
#
# @author Richard Böhme
class OrderedExperiment < ApplicationRecord
  belongs_to :order
  belongs_to :experiment, polymorphic: true

  scope :sorted, ->() { order(:sort) }
end
