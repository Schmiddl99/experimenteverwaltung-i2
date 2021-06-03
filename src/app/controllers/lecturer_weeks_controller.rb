# Controller that handles viewing and editing lecturer weeks.
#
# @author Richard Böhme
class LecturerWeeksController < ApplicationController

  # Entrypoint action for creating/editing a lecturer week. This renders the
  # form that allows setting the supposed lecturer or calendar week.
  #
  # GET /lecturer_weeks/new
  #
  # @author Richard Böhme
  def new
    @lecturer_week = LecturerWeek.new(year: Date.current.year, week: Date.current.cweek)
  end

  # Action that renders the lecturer week timetable from the params sent.
  # If the params are not valid or the lecturer week contains no orders the
  # {#new} action will be rendered.
  #
  # GET /lecturer_weeks
  #
  # @author Richard Böhme
  def show
    @lecturer_week = LecturerWeek.new(lecturer_week_params.merge(user: current_user)).decorate
    unless @lecturer_week.valid?
      return render "new"
    end

    if @lecturer_week.orders.blank?
      if current_user.lecturer?
        flash.now[:alert] = "In dieser Woche haben Sie keine Experimente gebucht!"
      else
        flash.now[:alert] = "In dieser Woche wurden von dem Dozenten #{@lecturer_week.lecturer.name} keine Experimente gebucht!"
      end

      render "new"
    end
  end

  private

  # Collects the params used by {#show}.
  #
  # @author Richard Böhme
  def lecturer_week_params
    params.require(:lecturer_week).permit(:year, :week, :lecturer_id)
  end

end
