# Model (not persisted) that represents a lecturer week.
#
# @author Richard Böhme
class LecturerWeek
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations::Callbacks
  include Draper::Decoratable

  MIN_YEAR = 2021

  attribute :year, :integer
  attribute :week, :integer
  attribute :lecturer_id, :integer

  # @return [User]
  attr_accessor :lecturer
  attr_accessor :date_range

  validates :year,
    numericality: {
      less_than_or_equal_to: -> (_) { Date.current.year },
      greater_than_or_equal_to: MIN_YEAR
    }

  validates :week,
    numericality: {
      less_than_or_equal_to: -> (model) { Date.commercial(model.year, -1).cweek },
      greater_than_or_equal_to: 1
    }

  validates :lecturer, presence: true

  # Constructor for the LecturerWeek class. It also fetches the
  # lecturer ({User}) if a +lecturer_id+ is given.
  # If a lecturer is passed as an attribute, it will always be
  # used (even if a +lecturer_id+ is present).
  #
  # @author Richard Böhme
  def initialize(attributes = {})
    user = attributes.delete(:user)

    super

    if user&.lecturer?
      @lecturer = user
    elsif lecturer_id
      @lecturer = User.find_by(id: lecturer_id, role: :lecturer)
    end
  end

  # Fetches and memoizes all {Order}s from the specified lecturer
  # in the chosen calendar week ordered by their +course_at+.
  # It also preloads the courses, ordered_experiments and experiments
  # of the order.
  #
  # @author Richard Böhme
  # @return [ActiveRecord::Relation<Order>] the fetched orders
  def orders
    @orders ||=
      Order.
        where(course_at: date_range, user: lecturer).
        order(:course_at).
        includes(:course, ordered_experiments: :experiment)
  end

  # Computes the date range of the given calendar week.
  #
  # @author Richard Böhme
  # @return [Range<ActiveSupport::TimeWithZone>] datetime range from beginning of the week to the end
  def date_range
    if errors.empty?
      @date_range ||= (
        current_week = Date.commercial(year, week).beginning_of_day
        current_week..current_week.end_of_week
      )
    end
  end

end
