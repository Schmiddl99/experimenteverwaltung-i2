# Model that represents a order for one course.
#
# @author Richard Böhme
class Order < ApplicationRecord
  belongs_to :course
  belongs_to :user
  has_many :ordered_experiments, -> { sorted }, dependent: :destroy
  accepts_nested_attributes_for :ordered_experiments

  before_validation :set_course_at

  attr_accessor :course_at_time
  attribute :course_at_date, :date

  validates :course_at_time,
      format: /\A([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]\z/,
      if: -> (_) { new_record? }

  validates :course_at_date,
      date: true,
      if: -> (_) { new_record? }

  validates :course_at,
      date: { after: ->(_) { Time.current }, allow_blank: true },
      if: -> (_) { new_record? }

  validates :ordered_experiments, length: { minimum: 1 }, on: [:create, :update]

  self.per_page = 10

  # Get all ordered experiments that are not marked for destruction.
  #
  # @author Richard Böhme
  # @return [Array<OrderedExperiment>] the ordered experiments
  def current_ordered_experiments
    self.ordered_experiments.reject(&:marked_for_destruction?)
  end

  private

  # Before validation happens, this will set the +course_at+ from
  # +course_at_date+ and +course_at_time+ if set.
  #
  # @author Richard Böhme
  def set_course_at
    if course_at_date.present? && course_at_time.present?
      self.course_at = "#{course_at_date} #{course_at_time.strip}"
    end
  end
end
