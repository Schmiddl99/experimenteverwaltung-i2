module LecturerWeekHelper

  # Return a hash containing the weeks of each year.
  # Format:
  #   {
  #     2021: {
  #       1: {
  #         start_of_week: '04.01.2021', end_of_week: '10.01.2021'
  #       }, ...
  #     }, ...
  #   }
  #
  # This is used to communicate this data to javascript code via data
  # attributes. This is used because javascript's default date library
  # isn't that powerful.
  #
  # @author Richard Böhme
  # @return [Hash]
  def year_data
    (LecturerWeek::MIN_YEAR..Date.current.year).each_with_object({}) do |year, hash|
      hash[year] = (1..Date.commercial(year, -1).cweek).each_with_object({}) do |week, year_hash|
        year_hash[week] = { start_of_week: I18n.l(Date.commercial(year, week, 1)), end_of_week: I18n.l(Date.commercial(year, week, 7)) }
      end
    end
  end

end
