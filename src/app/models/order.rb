class Order < ApplicationRecord
  belongs_to :course
  belongs_to :user
  has_many :ordered_experiments, dependent: :destroy
  accepts_nested_attributes_for :ordered_experiments

  before_validation :set_course_at

  attr_accessor :course_at_time
  attribute :course_at_date, :date

  validates :course_at_time, format: /\A([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]\z/
  validates :course_at_date, date: { after: ->(_) { Time.current } }
  validates :ordered_experiments, length: { minimum: 1 }, on: [:create, :update]

  private

  def set_course_at
    if course_at_date.present? && course_at_time.present?
      self.course_at = "#{course_at_date} #{course_at_time.strip}"
    end
  end
end
