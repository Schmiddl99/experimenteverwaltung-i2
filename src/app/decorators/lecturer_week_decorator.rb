class LecturerWeekDecorator < Draper::Decorator
  delegate_all

  # Returns the heading used for the lecturer week timetable.
  #
  # @example
  #   # => "KW 1. | 01.01.2021 - 07.01.2021 | WS 20/21"
  #
  # @author Richard Böhme
  # @return [String]
  def heading
    "KW #{week}. | #{l(date_range.first.to_date)} - #{l(date_range.last.to_date)} | #{semester}"
  end

  # Collects the comments from all orders in a lecturer week.
  #
  # @example
  #   # => "für Montag Chemie, Kommentar, für Dienstag Elektrotechnik, Kommentar 2"
  #
  # @author Richard Böhme
  # @return [String]
  def comment
    @comment ||=
      orders.map do |order|
        if order.comment.present?
          "für #{I18n.l(order.course_at, format: "%A")} #{course_name(order)}, #{order.comment}"
        end
      end.compact.join(', ')
  end

  # Localizes the passed order's +course_at+.
  #
  # @example
  #   # => "Mo 9:00 Uhr | 31.5.2021"
  #
  # @author Richard Böhme
  # @param [Order] order
  # @return [String]
  def course_at_header(order)
    I18n.l(order.course_at, format: "%a %-H:%M Uhr | %-d.%-m.%Y")
  end

  private

  # Return the appropriate semester description from the date range.
  # There are three cases that could happen:
  # * The first date of +date_range+ is in the summer (April to September) => summer semester
  # * The first date of +date_range+ is in the first part of the year (January to March) => winter semester from last year to current year
  # * The first date of +date_range+ is in the last part of the year (October to December) => winter semester from this year to next year
  #
  # @example date_range is from 3.5. - 9.5. 2021
  #   # => "SS 2021"
  #
  # @example date_range is from 11.10. - 18.10. 2021
  #   # => "WS 21/22"
  #
  # @example date_range is from 4.1. - 10.1. 2021
  #   # => "WS 20/21"
  #
  # @author Richard Böhme
  # @return [String]
  def semester
    year = date_range.first.year
    if (4..9).include?(date_range.first.month)
      "SS #{year}"
    elsif (10..12).include?(date_range.first.month)
      "WS #{short_year(year)}/#{short_year(year + 1)}"
    else
      "WS #{short_year(year - 1)}/#{short_year(year)}"
    end
  end

  # Returns a course name of an order. This can either be just the name saved
  # on the {Course} model or the name and the +alternative_course_name+ of the
  # order.
  #
  # @example Without +alternative_course_name+
  #   # => "Course Name"
  #
  # @example With +alternative_course_name+
  #   # => "Course Name (alternative Course Name)"
  #
  # @author Richard Böhme
  # @param [Order] order
  # @return [String]
  def course_name(order)
    order.course.name.tap do |name|
      if order.alternative_course_name.present?
        name << " (#{order.alternative_course_name})"
      end
    end
  end

  # Returns the last two digits of a year.
  #
  # @example
  #   short_year(2021) # => 21
  #
  # @author Richard Böhme
  # @param [Integer] year
  # @return [Integer]
  def short_year(year)
    year % 100
  end
end
