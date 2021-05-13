class OrderedExperiment < ApplicationRecord
  belongs_to :order
  belongs_to :experiment, polymorphic: true
end
